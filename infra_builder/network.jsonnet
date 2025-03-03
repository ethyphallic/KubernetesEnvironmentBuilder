{
  buildLatency(appFrom, appTo, delayMs):: {
    apiVersion: "chaos-mesh.org/v1alpha1",
    kind: "NetworkChaos",
    metadata: {
      name: "network-delay-%s-%s" %[appFrom, appTo],
      namespace: "scalablemine-hkr-infra"
    },
    spec: {
      action: "delay",
      mode: "all",
      selector: {
        namespaces: [
          "scalablemine-hkr-load",
          "scalablemine-hkr-sut",
          "scalablemine-hkr-kafka"
        ],
        nodeSelectors: {
          "kubernetes.io/hostname": appFrom
        }
      },
      direction: "both",
      target: {
        mode: "all",
        selector: {
          namespaces: [
            "scalablemine-hkr-load",
            "scalablemine-hkr-sut",
            "scalablemine-hkr-kafka"
          ],
          nodeSelectors: {
            "kubernetes.io/hostname": appTo
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