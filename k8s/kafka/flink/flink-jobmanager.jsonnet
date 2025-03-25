function(
    namespace,
    jobManagerCPU,
    jobManagerMemory,
    taskManagerCPU,
    taskManagerMemory,
    taskManagerReplicas
  )
[
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name: "flink-session-jobmanager",
      namespace: namespace,
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
                  cpu: jobManagerCPU,
                  memory: jobManagerMemory,
                },
                limits: {
                  cpu: jobManagerCPU,
                  memory: jobManagerMemory,
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
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: "flink-session-jobmanager",
      namespace: namespace,
    },
    spec: {
      ports: [
        {
          name: "rpc",
          port: 6123,
        },
        {
          name: "ui",
          port: 8081,
        },
      ],
      selector: {
        app: "flink",
        component: "jobmanager",
      },
    },
  }
]