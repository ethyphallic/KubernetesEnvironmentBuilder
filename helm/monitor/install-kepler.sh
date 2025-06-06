DIR="$(dirname "$0")"

PREFIX=$(cat $DIR/../../config.json | jq -r .context.prefix)
NAMESPACE=$(cat $DIR/../../config.json | jq -r .monitor.namespace)
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

HELM_CMD=""
CONTEXT=$(kubectl config current-context)
if [ "$CONTEXT" != "minikube" ]; then
  HELM_CMD="--set createGlobalResources=false --skip-crds" # External cluster
fi

helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
helm install kepler kepler/kepler --set serviceMonitor.enabled=true --set serviceMonitor.labels.release=prometheus $HELM_CMD -n $NAMESPACE
