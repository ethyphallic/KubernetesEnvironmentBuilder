function check_enabled() {
  [ $(cat ../config.json | jq $1) == "true" ]
}

helm/kafka/install-strimzi.sh
check_enabled .infra.chaosMeshEnabled && helm/install-chaos-mesh.sh
check_enabled .kafka.uiEnabled && helm/kafka/install-kafka-ui.sh
check_enabled .monitor.enabled && helm/monitor/install-prometheus.sh
check_enabled .monitor.energyMonitorEnabled && ./helm/monitor/install-kepler.sh
