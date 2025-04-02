function(namespace="monitor", scrapeInterval="10s") {
  namespaceOverride: namespace,
  namespace: namespace,
  prometheus: {
    enabled: true,
    prometheusSpec: {
      scrapeInterval: scrapeInterval
    },
    service: {
      type: "NodePort"
    }
  },
  grafana: {
    enabled: true,
    serviceMonitor: {
      interval: scrapeInterval
    },
    service: {
      type: "NodePort"
    }
  },
  prometheusOperator: {
    enabled: false
  },
  crds: {
    enabled: false
  },
  alertmanager: {
    enabled: false
  },
  thanosRuler: {
    enabled: false
  },
  kubeStateMetrics: {
    enabled: false
  },
  coreDns: {
    enabled: false
  },
  kubeControllerManager: {
    enabled: false
  },
  kubeEtcd: {
    enabled: false
  },
  kubeProxy: {
    enabled: false
  },
  kubeScheduler: {
    enabled: false
  },
  nodeExporter: {
    enabled: false
  }
}
