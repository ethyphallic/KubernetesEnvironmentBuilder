function(
  namespace,
  taskManagerReplicas,
  taskManagerCPU,
  taskManagerMemory
) {
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: "flink-session-taskmanager",
    namespace: namespace,
  },
  spec: {
    replicas: taskManagerReplicas,
    selector: {
      matchLabels: {
        app: "flink",
        component: "taskmanager",
      },
    },
    template: {
      metadata: {
        labels: {
          app: "flink",
          component: "taskmanager",
        },
      },
      spec: {
        containers: [
          {
            name: "taskmanager",
            image: "flink:1.17",
            resources: {
              requests: {
                cpu: taskManagerCPU,
                memory: taskManagerMemory,
              },
              limits: {
                cpu: taskManagerCPU,
                memory: taskManagerMemory,
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
                containerPort: 6121,
                name: "data",
              },
              {
                containerPort: 6122,
                name: "rpc",
              },
            ],
            command: ["/docker-entrypoint.sh"],
            args: ["taskmanager"],
          },
        ],
      },
    },
  },
}
