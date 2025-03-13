DIR="$(dirname "$0")"
NAMESPACE=$(cat $DIR/../../config.json | jq .monitor.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-values-instance.yaml --set createGlobalResources=false --skip-crds -n $NAMESPACE