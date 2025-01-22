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
          "autoscaling"
        ],
        resources: [
          "deployments",
          "replicasets",
          "pods",
          "services",
          "configmaps",
          "statefulsets",
          "endpoints",
          "jobs",
          "events",
          "pods/log",
          "pods/exec",
          "deployments/scale",
          "statefulsets/scale",
          "pods/attach",
          "persistentvolumes",
          "persistentvolumeclaims",
          "replicationcontrollers",
          "horizontalpodautoscalers"
        ],
        verbs: [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
          "logs",
          "exec",
          "cp",
          "scale",
          "top",
          "edit",
          "describe"
        ]
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