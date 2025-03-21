function(namespace, bootstrapServer) {
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: "distributed-event-factory",
    namespace: namespace,
    labels: {
      app: "distributed-event-factory"
    }
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: "distributed-event-factory"
      }
    },
    template: {
      metadata: {
        labels: {
          app: "distributed-event-factory"
        }
      },
      spec: {
        containers: [
          {
            name: "distributed-event-factory",
            image: "hendrikreiter/distributed_event_factory:0.2.2",
            imagePullPolicy: "IfNotPresent",
            env: [
              {
                 name: "LOAD",
                 value: "1"
              },
              {
                 name: "SIMULATION",
                 value: "load-config.json"
              },
              {
                 name: "DATASOURCE",
                 value: "assemblyline"
              },
              {
                 name: "SINK",
                 value: "sink-config.json"
              },
              {
                 name: "ROOT",
                 value: "/app"
              }
            ],
            ports: [
              {
                containerPort: 8080
              }
            ],
            resources: {
              requests: {
                cpu: "300m",
                memory: "200Mi"
              },
            },
            volumeMounts: [
              {
                 name: "def-datasource-config",
                 mountPath: "/app/config/datasource/assemblyline"
              },
              {
                 name: "def-load-config",
                 mountPath: "/app/config/simulation"
              },
              {
                 name: "def-sink-config",
                 mountPath: "/app/config/sink"
              }
            ]
          }
        ],
        volumes: [
          {
            name: "def-datasource-config",
            configMap: {
              name: "def-datasource"
            }
          },
          {
            name: "def-load-config",
            configMap: {
              name: "def-load"
            }
          },
          {
            name: "def-sink-config",
            configMap: {
              name: "def-sink"
            }
          }
        ]
      }
    }
  }
}