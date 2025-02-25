DIR="$(dirname "$0")"
function check_enabled() {
  echo $1
  [ $(cat $DIR/../config.json | jq $1) == "true" ]
}

ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  (check_enabled .kafka.strimziEnabled && cd $DIR/kafka/ && ./install-strimzi.sh $ID)
  (check_enabled .infra.chaosMeshEnabled && cd $DIR/infra/ && ./install-choas-mesh.sh $ID)
  (check_enabled .kafka.uiEnabled && cd $DIR/kafka/ && ./install-kafka-ui.sh $ID)
  (check_enabled .monitor.prometheusEnabled && cd $DIR/monitor/ && ./install-prometheus.sh $ID)
  (check_enabled .monitor.energyMonitorEnabled && cd $DIR/monitor&& ./install-kepler.sh $ID)
fi