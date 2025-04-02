DIR=$(dirname "$(realpath "$0")")

PREFIX=$(cat $DIR/../../config.json | jq -r .context.prefix)
NAMESPACE=$(cat $DIR/../../config.json | jq -r .kafka.namespace)
if [ -z $NAMESPACE ]; then
  echo "No explicit namespace set, trying prefix as namespace ..."
  if [ -z $PREFIX ]; then
    echo "Prefix also not set. Abort."
    exit 1
  else
    NAMESPACE=$PREFIX
  fi
else
  if [ ! -z $PREFIX ]; then
    NAMESPACE="$PREFIX$NAMESPACE"
  fi
fi
echo "Selected namespace : $NAMESPACE"

helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts

if command -v jsonnet >/dev/null 2>&1; then
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

HELM_CMD=""
CONTEXT=$(kubectl config current-context)
if [ "$CONTEXT" != "minikube" ]; then
  HELM_CMD="--set createGlobalResources=false --skip-crds" # External cluster
fi

helm install kafka-ui kafka-ui/kafka-ui -f kafka-ui-values.json $HELM_CMD -n $NAMESPACE
sh -c -e "rm $DIR/kafka-ui-values.json $DIR/config.json $DIR/global.jsonnet"