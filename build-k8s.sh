DIR=$(dirname "$(realpath "$0")")
[ -d "$DIR/build" ] && sh -c -e "rm -r $DIR/build"
mkdir -p "$DIR/build/cluster"
mkdir -p "$DIR/build/cluster/namespace"
mkdir -p "$DIR/build/sut"
mkdir -p "$DIR/build/sut0"
mkdir -p "$DIR/build/sut1"
mkdir -p "$DIR/build/sut/flink-session"
mkdir -p "$DIR/build/kafka"
mkdir -p "$DIR/build/kafka/topic"
mkdir -p "$DIR/build/kafka/ui"
mkdir -p "$DIR/build/load"
mkdir -p "$DIR/build/warmup"
mkdir -p "$DIR/build/load/datasource"
mkdir -p "$DIR/build/load/load"
mkdir -p "$DIR/build/load/sink"
mkdir -p "$DIR/build/chaos"
mkdir -p "$DIR/build/monitor"
mkdir -p "$DIR/build/monitor/podmonitor"
mkdir -p "$DIR/build/monitor/prometheus"
mkdir -p "$DIR/build/infra"
mkdir -p "$DIR/build/helm"

jsonnet -m $DIR $DIR/k8s/main.jsonnet

if [[ -z $(jsonnet config.jsonnet | jq .context.prefix) ]]; then
  NAMESPACE="monitor"
fi
NAMESPACE=$(jsonnet config.jsonnet | jq .context.prefix)

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts > /dev/null
helm template prometheus prometheus-community/kube-prometheus-stack --namespace $NAMESPACE --values build/helm/prometheus-values.json --skip-tests --output-dir build/monitor/prometheus