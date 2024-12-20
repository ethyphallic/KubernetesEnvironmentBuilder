local config = import '../../config.json';
local global = (import '../../global.jsonnet').bootstrapServer;

local values = {
  namespace: "kafka",
  service: {
    type: "NodePort"
  },
  yamlApplicationConfig: {
    kafka: {
      clusters: [
        {
          name: config.kafka.clusterName,
          bootstrapServers: global
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
};

{
    "kafka-ui-values.json": values
}