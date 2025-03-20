{
  flinkSessionCluster(
    namespace, 
    jobManagerCPU, 
    jobManagerMemory, 
    taskManagerCPU, 
    taskManagerMemory, 
    taskManagerReplicas
  )::
  {
    // JobManager Deployment
    jobManagerDeployment: {
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

    // JobManager Service
    jobManagerService: {
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
    },

    // TaskManager Deployment
    taskManagerDeployment: {
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
    },
  },
}