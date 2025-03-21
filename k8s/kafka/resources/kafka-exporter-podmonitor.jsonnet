function(clusterName, namespace) {
  apiVersion: "monitoring.coreos.com/v1",
  kind: "PodMonitor",
  metadata: {
    name: clusterName + "-kafka-exporter-podmonitor",
    namespace: namespace,
    labels: {
      release: "prometheus"
    }
  },
  spec: {
    selector: {
      matchLabels: {
        "strimzi.io/name": clusterName + "-kafka-exporter"
      }
    },
    podMetricsEndpoints: [
      {
        path: "/metrics",
        port: "tcp-prometheus"
      }
    ]
  }
}