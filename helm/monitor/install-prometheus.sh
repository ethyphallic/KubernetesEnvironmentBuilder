DIR="$(dirname "$0")"
PREFIX=$(cat $DIR/../../config.json | jq -r .context.prefix)
NAMESPACE=$PREFIX-$(cat $DIR/../../config.json | jq -r .monitor.namespace)


if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi

HELM_CMD=""
CONTEXT=$(kubectl config current-context)
if [ "$CONTEXT" != "minikube" ]; then
  HELM_CMD="--set createGlobalResources=false --skip-crds" # External cluster
fi

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-values-instance.yaml $HELM_CMD -n $NAMESPACE