ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  helm install kafka-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --set createGlobalResources=false --skip-crds -n scalablemine-$ID-kafka
fi