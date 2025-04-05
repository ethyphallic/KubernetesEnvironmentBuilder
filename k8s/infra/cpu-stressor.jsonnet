function(
  definition={
    workers: 5,
    load: 100,
    target: "node1"
  },
  externalParameter={
    namespace: "infra",
    affectedNamespaces: ["namespace"]
  }
) {
  apiVersion: "chaos-mesh.org/v1alpha1",
  kind: "StressChaos",
  metadata: {
    name: "cpu-stress",
    namespace: externalParameter.namespace
  },
  spec: {
    mode: "all",
    selector: {
      nodeSelectors: {
        "kubernetes.io/hostname": definition.target
      },
      namespaces: externalParameter.affectedNamespaces
    },
    stressors: {
      cpu: {
        workers: definition.workers,
        load: definition.load
      }
    }
  }
}