function(
  name1="app1",
  name2="app2",
  definition={
   latency: 200
  },
  externalParameters={
    namespace: "infra",
    affectedNamespaces: []
  }
) {
  apiVersion: "chaos-mesh.org/v1alpha1",
  kind: "NetworkChaos",
  metadata: {
    name: "network-delay-%s-%s" %[name1, name2],
    namespace: externalParameters.namespace
  },
  spec: {
    action: "delay",
    mode: "all",
    selector: {
      namespaces: externalParameters.affectedNamespaces,
      nodeSelectors: {
        "kubernetes.io/hostname": name1
      }
    },
    direction: "both",
    target: {
      mode: "all",
      selector: {
        namespaces: externalParameters.affectedNamespaces,
        nodeSelectors: {
          "kubernetes.io/hostname": name2
        }
      }
    },
    delay: {
      latency: '%sms' %[definition.latency],
      correlation: '100',
      jitter: '0ms'
    }
  }
}