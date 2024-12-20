{
    podFailure(duration, namespace, labelSelector, iteration=0):: {
        apiVersion: "chaos-mesh.org/v1alpha1",
        kind: "PodChaos",
        metadata: {
          name: "pod-failure-%s" %[iteration],
          namespace: "infra"
        },
        spec: {
            action: "pod-failure",
            mode: "one",
            duration: duration,
            selector: {
                namespaces: [namespace],
                labelSelectors: labelSelector
            }
        }
    },
    podKill():: {},
}