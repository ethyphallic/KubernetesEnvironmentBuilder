DIR=$(dirname "$(realpath "$0")")
IMAGE_NAME="scalablemine-cluster-container"

# Check container status
if docker container inspect "$IMAGE_NAME" &> /dev/null; then
    # Container exists, check if it's running
    if [ "$(docker container inspect -f '{{.State.Running}}' "$IMAGE_NAME")" == "true" ]; then
        echo "Container $IMAGE_NAME is already running, attaching to it..."
        docker attach "$IMAGE_NAME"
    else
        echo "Container $IMAGE_NAME exists but is not running, starting it..."
        docker start -i "$IMAGE_NAME"
    fi
else
    # Container doesn't exist, create and run it
    # First check image
    if (docker image inspect "$IMAGE_NAME" &> /dev/null); then
      echo Found image with name $IMAGE_NAME
    else
      echo Building image $IMAGE_NAME
      docker build -t $IMAGE_NAME .
    fi
    # Then create a new container with said image
    echo "Creating and starting new container $IMAGE_NAME..."
    MSYS_NO_PATHCONV=1 docker run -it \
      -v $HOME/.kube/config:/root/.kube/config \
      -v $DIR:/app \
      --network=host --name=$IMAGE_NAME $IMAGE_NAME
fi