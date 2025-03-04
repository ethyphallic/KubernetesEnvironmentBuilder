DIR=$(dirname "$(realpath "$0")")
IMAGE_NAME="cluster-container"
IMAGE_PRESENT=$(docker image inspect "$IMAGE_NAME" >/dev/null 2>&1)

if ! $IMAGE_PRESENT; then
  MSYS_NO_PATHCONV=1 docker build -t $IMAGE_NAME .
fi

MSYS_NO_PATHCONV=1 docker run -it \
  -v $HOME/.kube/config:/root/.kube/config \
  -v $DIR:/app \
  --network=host $IMAGE_NAME