{
  buildCpuStressor(target): {
    apiVersion: "chaos-mesh.org/v1alpha1",
    kind: "StressChaos",
    metadata: {
      name: "cpu-stress",
    },
    spec: {
      mode: "all",
      selector: {
        labelSelectors: {
          app: target
        }
      },
      stressors: {
        cpu: {
          workers: 1,
          load: 75
        }
      }
    }
  }
}