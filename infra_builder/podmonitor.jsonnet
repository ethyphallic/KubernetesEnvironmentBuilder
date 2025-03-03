{
  createPodMonitor(name, matchLabel):: {
    apiVersion: "monitoring.coreos.com/v1",
    kind: "PodMonitor",
    metadata: {
      name: name,
      namespace: "scalablemine-hkr-sut",
      labels: {
        release: "prometheus"
      }
    },
    spec: {
      selector: {
        matchLabels: matchLabel
      },
      podMetricsEndpoints: [
        {
          path: "/metrics",
          port: "metrics"
        }
      ]
    }
  }
}