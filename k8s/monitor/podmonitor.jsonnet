function(
  name,
  definition={
    matchLabel: "label"
  },
  externalParameter={
    namespace: "monitor"
  }
  ) {
    apiVersion: "monitoring.coreos.com/v1",
    kind: "PodMonitor",
    metadata: {
      name: name,
      namespace: externalParameter.namespace,
      labels: {
        release: "prometheus"
      }
    },
    spec: {
      selector: {
        matchLabels: {
          app: definition.matchLabel
        }
      },
      podMetricsEndpoints: [
        {
          path: "/metrics",
          port: "metrics"
        }
      ]
    }
  }