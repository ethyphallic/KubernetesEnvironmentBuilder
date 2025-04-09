DIR=$(dirname "$(realpath "$0")")
[ -d "$DIR/build" ] && sh -c -e "rm -r $DIR/build"

jsonnet -c -m $DIR $DIR/k8s/main.jsonnet
NAMESPACE=$(cat $DIR/build/cluster-config.json | jq -r .monitorNamespace)
echo $NAMESPACE

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts > /dev/null
helm template prometheus prometheus-community/kube-prometheus-stack --namespace $NAMESPACE --values build/helm/prometheus-values.json --skip-tests --output-dir build/monitor/prometheus