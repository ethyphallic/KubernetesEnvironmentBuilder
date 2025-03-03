ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  helm repo add chaos-mesh https://charts.chaos-mesh.org
  helm install chaos-mesh chaos-mesh/chaos-mesh --set createGlobalResources=false --skip-crds -n scalablemine-$ID-infra
fi