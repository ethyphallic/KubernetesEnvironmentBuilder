DIR="$(dirname "$0")"
NAMESPACE=$(cat $DIR/../../config.json | jq -r .monitor.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi
helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
helm install kepler kepler/kepler --set serviceMonitor.enabled=true --set serviceMonitor.labels.release=prometheus --set createGlobalResources=false --skip-crds -n $NAMESPACE
