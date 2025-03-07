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
  },
  buildFromConfig(topology):: [
    local network_node_def = std.get(topology, node).network;
    $.buildLatency(
        appFrom=node,
        appTo=target_node,
        delayMs=std.get(network_node_def, target_node).latency
    )
    for node in std.objectFields(topology)
    for target_node in std.objectFields(std.get(topology, node).network)
  ]
}