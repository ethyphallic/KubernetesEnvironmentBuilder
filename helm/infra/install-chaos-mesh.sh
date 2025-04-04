DIR="$(dirname "$0")"

PREFIX=$(cat $DIR/../../config.json | jq -r .context.prefix)
NAMESPACE=$(cat $DIR/../../config.json | jq -r .infra.namespace)
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

helm repo add chaos-mesh https://charts.chaos-mesh.org

HELM_CMD=""
CONTEXT=$(kubectl config current-context)
if [ "$CONTEXT" != "minikube" ]; then
  HELM_CMD="--set createGlobalResources=false --skip-crds" # External cluster
fi

helm install chaos-mesh chaos-mesh/chaos-mesh $HELM_CMD -n $NAMESPACE