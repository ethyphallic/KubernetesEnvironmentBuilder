function(name,
  definition={
    replicas: "1",
    cpu: "1",
    memory: "1Gi"
  },
  externalParameters= {
    namespace: "data"
  }
)
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name: "flink-session-jobmanager",
      namespace: externalParameters.namespace,
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: "flink",
          component: "jobmanager",
        },
      },
      template: {
        metadata: {
          labels: {
            app: "flink",
            component: "jobmanager",
          },
        },
        spec: {
          containers: [
            {
              name: "jobmanager",
              image: "flink:1.17",
              resources: {
                requests: {
                  cpu: definition.cpu,
                  memory: definition.memory,
                },
                limits: {
                  cpu: definition.cpu,
                  memory: definition.memory,
                },
              },
              env: [
                {
                  name: "FLINK_PROPERTIES",
                  value: "jobmanager.rpc.address=flink-jobmanager\n" +
                         "taskmanager.numberOfTaskSlots=32\n" +
                         "parallelism.default=4",
                },
              ],
              ports: [
                {
                  containerPort: 6123,
                  name: "rpc",
                },
                {
                  containerPort: 8081,
                  name: "ui",
                },
              ],
              command: ["/docker-entrypoint.sh"],
              args: ["jobmanager"],
            },
          ],
        },
      },
    },
  }