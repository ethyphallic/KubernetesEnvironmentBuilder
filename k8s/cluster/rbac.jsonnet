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
  getRoleBinding(name, username):: {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "RoleBinding",
    metadata: {
      name: "rolebinding-" + name,
      namespace: name,
    },
    roleRef: {
      apiGroup: "rbac.authorization.k8s.io",
      kind: "Role",
      name: "role-" + name,
    },
    subjects: [
      {
        apiGroup: "rbac.authorization.k8s.io",
        kind: "User",
        name: username
      }
    ]
  }
}