function(clusterName, namespace) {
  apiVersion: "monitoring.coreos.com/v1",
  kind: "PodMonitor",
  metadata: {
    name: clusterName + "-kafka-resources-metrics",
    namespace: namespace,
    labels: {
      release: "prometheus"
    }
  },
  spec: {
    selector: {
      matchLabels: {
        "strimzi.io/name": clusterName + "-kafka"
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