DIR="$(dirname "$0")"
NAMESPACE=$(cat $DIR/../../config.json | jq -r .kafka.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi
helm install kafka-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --set createGlobalResources=false --skip-crds -n $NAMESPACE