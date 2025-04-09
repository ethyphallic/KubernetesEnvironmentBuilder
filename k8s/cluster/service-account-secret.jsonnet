function(name, namespace) {
  apiVersion: "v1",
  kind: "Secret",
  type: "kubernetes.io/service-account-token",
  metadata: {
    name: "token-secret-%s" %[name],
    namespace: namespace,
    annotations: {
      "kubernetes.io/service-account.name": name
    }
  }
}
