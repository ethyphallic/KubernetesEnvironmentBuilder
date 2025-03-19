DIR="$(dirname "$0")"
NAMESPACE=$(cat $DIR/../../config.json | jq -r .infra.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh --set createGlobalResources=false --skip-crds -n $NAMESPACE