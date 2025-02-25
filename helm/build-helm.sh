DIR="$(dirname "$0")"
function check_enabled() {
  echo $1
  [ $(cat $DIR/../config.json | jq $1) == "true" ]
}

($DIR/kafka/install-strimzi.sh)
(check_enabled .infra.chaosMeshEnabled && cd $DIR/infra/ && ./install-chaos-mesh.sh)
(check_enabled .kafka.uiEnabled && cd $DIR/kafka/ && ./install-kafka-ui.sh)
(check_enabled .monitor.prometheusEnabled && cd $DIR/monitor/ && ./install-prometheus.sh)
(check_enabled .monitor.energyMonitorEnabled && cd $DIR/monitor&& ./install-kepler.sh)
kubectl create ns sut
kubectl create ns load
