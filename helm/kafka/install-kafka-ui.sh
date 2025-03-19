DIR=$(dirname "$(realpath "$0")")
NAMESPACE=$(cat $DIR/../../config.json | jq -r .kafka.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi
helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts

JSONNET_PRESENT=$(command -v jsonnet >/dev/null 2>&1)
if $JSONNET_PRESENT; then
  # Use locally present jsonnet (Also used in the interactive docker container)
  echo "Using local jsonnet installation"
  cp $DIR/../../config.json $DIR/config.json
  jsonnet -m $DIR \
        -J $DIR/../../k8s \
        $DIR/kafka-ui-values.jsonnet
else
  # Try jsonnet builder in docker
  echo "Using docker jsonnet installation"
  # Note: MSYS_NO_PATHCONV=1 will be ignored by Linux / Mac | Used for Windows (Git Bash)
  MSYS_NO_PATHCONV=1 docker run --rm --name jsonnet \
      -v $DIR/../../k8s/global.jsonnet:/src/global.jsonnet \
      -v $DIR/../../config.json:/src/config.json \
      -v $DIR:/src \
      syseleven/jsonnet-builder -m /src /src/kafka-ui-values.jsonnet
fi

helm install kafka-ui kafka-ui/kafka-ui -f kafka-ui-values.json --set createGlobalResources=false --skip-crds -n $NAMESPACE
sh -c -e "rm $DIR/kafka-ui-values.json $DIR/config.json $DIR/global.jsonnet"