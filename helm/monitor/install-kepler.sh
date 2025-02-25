ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
  helm install kepler kepler/kepler --set serviceMonitor.enabled=true --set serviceMonitor.labels.release=prometheus --set createGlobalResources=false --skip-crds -n scalablemine-$ID-monitor
fi