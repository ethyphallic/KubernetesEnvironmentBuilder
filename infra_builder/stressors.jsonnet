{
  buildCpuStressor(target, load):: {
    apiVersion: "chaos-mesh.org/v1alpha1",
    kind: "StressChaos",
    metadata: {
      name: "cpu-stress",
      namespace: "infra"
    },
    spec: {
      mode: "all",
      selector: {
        labelSelectors: {
          "ecoscape/node": target
        },
        namespaces: [
          "sut",
          "kafka"
        ]
      },
      stressors: {
        cpu: {
          workers: 1,
          load: load
        }
      }
    }
  },
  buildMemoryStressor(target, memorySize): {
    apiVersion: "chaos-mesh.org/v1alpha1",
    kind: "StressChaos",
    metadata: {
      name: "memory-stress",
      namespace: "infra"
    },
    spec: {
      mode: "all",
      selector: {
        labelSelectors: {
          "ecoscape/node": target
        },
        namespaces: [
          "sut",
          "kafka"
        ]
      },
      stressors: {
        memory: {
          workers: 1,
          size: memorySize
        }
      }
    }
  }
}