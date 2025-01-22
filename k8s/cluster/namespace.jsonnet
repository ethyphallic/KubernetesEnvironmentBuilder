{
  createNamespace(name): {
    apiVersion: "v1",
    kind: "Namespace",
    metadata: {
      name: name,
    },
    spec: {
      finalizers: [
        "kubernetes"
      ]
    }
  }
}