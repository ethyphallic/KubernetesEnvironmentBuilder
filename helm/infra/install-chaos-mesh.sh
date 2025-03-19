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
  if [ -z $PREFIX ]; then
    NAMESPACE="$PREFIX-$NAMESPACE"
  fi
fi
echo "Selected namespace : $NAMESPACE"

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh --set createGlobalResources=false --skip-crds -n $NAMESPACE