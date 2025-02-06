{
  buildLatency(appFrom, appTo, delayMs):: {
    apiVersion: "chaos-mesh.org/v1alpha1",
    kind: "NetworkChaos",
    metadata: {
      name: "network-delay-%s-%s" %[appFrom, appTo],
      namepace: "infra"
    },
    spec: {
      action: "delay",
      mode: "all",
      selector: {
        namespaces: [
          "load",
          "sut",
          "kafka"
        ],
        labelSelectors: {
          "ecoscape/node": appFrom
        }
      },
      direction: "both",
      target: {
        mode: "all",
        selector: {
          namespaces: [
            "load",
            "sut",
            "kafka"
          ],
          labelSelectors: {
            "ecoscape/node": appTo
          }
        }
      },
      delay: {
        latency: '%sms' %[delayMs],
        correlation: '100',
        jitter: '0ms'
      }
    }
  }
}