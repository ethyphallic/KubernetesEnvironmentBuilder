DIR=$(dirname "$(realpath "$0")")
IMAGE_NAME="scalablemine-cluster-container"
CONTAINER_NAME=$IMAGE_NAME

# Prepare Container
# > Check current status
if docker container inspect "$CONTAINER_NAME" &> /dev/null; then
  # > Exists; Check running status
  if [ "$(docker container inspect -f '{{.State.Running}}' "$CONTAINER_NAME")" == "true" ]; then
    echo Container $CONTAINER_NAME is already running, attaching to it...
    docker attach $CONTAINER_NAME
  else
    echo Container $CONTAINER_NAME exists but is not running, starting it...
    docker start -i $CONTAINER_NAME
  fi
else
  # > Doesn't exis; Check image status
  if docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo Found image with name $IMAGE_NAME
  else
    echo Image $IMAGE_NAME not found, building ...
    docker build -t $IMAGE_NAME $DIR
  fi

  # > Build container
  # Note: MYSY_NO_PATH_CONV is for execution on windows (git bash) and will be ignored on Linux / Mac
  echo Creating new container $CONTAINER_NAME ...
  MSYS_NO_PATHCONV=1 docker run -it \
      -v $HOME/.kube/config:/root/.kube/config \
      -v $DIR:/app \
      --network=host --name=$CONTAINER_NAME \
      $IMAGE_NAME
fi