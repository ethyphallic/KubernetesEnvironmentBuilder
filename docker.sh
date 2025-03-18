#/bin/bash
DIR=$(dirname "$(realpath "$0")")
CMDNAME=${0##*/}
usage() {
  cat << USAGE >&2
Script to build and start an interactive docker container for this project.
Usage:
  $CMDNAME [-- command args]
  -f  | --file    PATH   Path to Dockerfile location. Default: Location of script
  -n  | --name    NAME   Name of the resulting docker container.
  -r  | --rebuild        Rebuilds the image from scratch regardless if it exists already
  -rm | --remove         Removes the container after exiting the interactive shell
  -t  | --tag     TAG    Tag of the resulting docker image
  --help                 Displays this message
USAGE
  exit 1
}

# Process arguments
while [[ $# -gt 0 ]]
do
  case "$1" in
    -f | --file )
    DOCKERFILE_LOCATION="$2"
    shift 2
    ;;
    -n | --name )
    DOCKERCONTAINER_NAME="$2"
    shift 2
    ;;
    -r | --rebuild )
    DOCKERIMAGE_REBUILD=1
    shift 1
    ;;
    -rm | --remove )
    DOCKERCONTAINER_REMOVE=1
    shift 1
    ;;
    -t | --tag )
    DOCKERIMAGE_TAG="$2"
    shift 2
    ;;
    --help)
    usage
    ;;
    *)
    echo "Unknown argument: $1. Use --help for more information"
    exit 1
    ;;
  esac
done

DOCKERIMAGE_REBUILD=${DOCKERIMAGE_REBUILD:-0}
DOCKERIMAGE_REMOVE=${DOCKERIMAGE_REMOVE:-0}

if [ "$DOCKERFILE_LOCATION" == "" ]; then
  DOCKERFILE_LOCATION=$DIR
fi
if [ "$DOCKERCONTAINER_NAME" == "" ]; then
  DOCKERCONTAINER_NAME="ecoscape"
fi
if [ "$DOCKERIMAGE_TAG" == "" ]; then
  DOCKERIMAGE_TAG="ecoscape"
fi

# Prepare Container
# > Check current status
if docker container inspect "$DOCKERCONTAINER_NAME" &> /dev/null; then
  # > Exists; Check running status
  if [ "$(docker container inspect -f '{{.State.Running}}' "$DOCKERCONTAINER_NAME")" == "true" ]; then
    echo Container $DOCKERCONTAINER_NAME is already running, attaching to it...
    DOCKER_CMD="docker attach $DOCKERCONTAINER_NAME"
  else
    echo Container $DOCKERCONTAINER_NAME exists but is not running, starting it...
    DOCKER_CMD="docker start -i $DOCKERCONTAINER_NAME"
  fi
else
  # > Doesn't exis; Check image status
  if [ $DOCKERIMAGE_REBUILD -ne 0 ]; then 
    # Rebuild enabled
    echo Rebuilding image ...
    docker build --no-cache -t $DOCKERIMAGE_TAG $DOCKERFILE_LOCATION
  else
    # Rebuild disabled
    if docker image inspect "$DOCKERIMAGE_TAG" &> /dev/null; then
      # Image already exists
      echo Found image with name $DOCKERIMAGE_TAG
    else
      # Image doesn't exists
      echo Image $DOCKERIMAGE_TAG not found, building ...
      docker build -t $DOCKERIMAGE_TAG $DOCKERFILE_LOCATION
    fi
  fi
  echo Creating new container $DOCKERCONTAINER_NAME ...

  # Base command
  DOCKER_CMD="MSYS_NO_PATHCONV=1 docker run -it \
      -v $HOME/.kube/config:/root/.kube/config"

  # Detect minikube
  if minikube status | grep -q "host: Running"; then
      echo "Minikube detected, Switching context to minikube..."
      DOCKER_CMD="$DOCKER_CMD -e MINIKUBE=1 -v $HOME/.minikube:/root/.minikube"
  else
      echo "No minikube detected, keeping host context..."
  fi
  # Finish command
  DOCKER_CMD="$DOCKER_CMD -v $DIR:/app --network=host --name=$DOCKERCONTAINER_NAME $DOCKERIMAGE_TAG"
  eval $DOCKER_CMD
fi
eval $DOCKER_CMD

if [ $DOCKERCONTAINER_REMOVE -ne 0 ]; then
  echo "Removing container $DOCKERCONTAINER_NAME ..."
  docker container rm $DOCKERCONTAINER_NAME
fi