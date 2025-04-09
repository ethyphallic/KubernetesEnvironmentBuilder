{
  getRole(namespace):: {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "Role",
    metadata: {
      name: "role-" + namespace,
      namespace: namespace,
    },
    rules: [
      {
        apiGroups: [
          "",
          "extensions",
          "apps",
          "batch",
          "metrics.k8s.io",
          "autoscaling",
          "monitoring.coreos.com/v1",
        ],
        resources: ["*"],
        verbs: ["*"]
      }
    ]
  },
  getRoleBinding(namespace, serviceAccountName, serviceAccountNamespace):: {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "RoleBinding",
    metadata: {
      name: "rolebinding-" + namespace,
      namespace: namespace,
    },
    roleRef: {
      apiGroup: "rbac.authorization.k8s.io",
      kind: "Role",
      name: "role-" + namespace,
    },
    subjects: [
      {
        apiGroup: "",
        kind: "ServiceAccount",
        name: serviceAccountName,
        namespace: serviceAccountNamespace
      }
    ]
  },
}