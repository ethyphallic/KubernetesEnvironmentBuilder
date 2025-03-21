function(namespace, clusterName, bootstrapServer) {
  namespace: namespace,
  service: {
    type: "NodePort"
  },
  yamlApplicationConfig: {
    kafka: {
      clusters: [
        {
          name: clusterName,
          bootstrapServers: bootstrapServer
        }
      ]
    },
    auth: {
      type: "disabled"
    },
    management: {
      health: {
        ldap: {
          enabled: false
        }
      }
    }
  }
}