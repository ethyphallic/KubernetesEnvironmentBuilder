function(namespace, topic, bootstrapServer)
[
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name: "load-backend",
      namespace: namespace,
      labels: {
        app: "load-backend"
      }
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: "load-backend"
        }
      },
      template: {
        metadata: {
          labels: {
            app: "load-backend"
          }
        },
        spec: {
          containers: [
            {
              name: "load-backend",
              image: "hendrikreiter/def-loadtest-backend:0.1.0",
              imagePullPolicy: "IfNotPresent",
              env: [
                {
                   name: "TOPIC",
                   value: topic
                },
                {
                   name: "BOOTSTRAP_SERVER",
                   value: bootstrapServer
                }
              ],
              resources: {
                requests: {
                  cpu: "750m",
                  memory: "250Mi"
                },
              },
              ports: [
                {
                  containerPort: 8080
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
       name: "load-backend",
       namespace: namespace
    },
    spec: {
       selector: {
           app: "load-backend"
       },
       ports: [
         {
           port: 8080,
           targetPort: 8080
         }
       ]
    }
  }
]