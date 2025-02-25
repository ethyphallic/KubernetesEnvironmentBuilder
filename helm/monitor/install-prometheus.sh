ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-values.yaml --set createGlobalResources=false --skip-crds -n scalablemine-$ID-monitor
fi