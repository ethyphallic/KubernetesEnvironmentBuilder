{
  build(appName, locationLabel, bootstrapServer, topic, modelDepth, replicas, memory="128Mi", cpu="500m"):: {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name: appName,
      namespace: "scalablemine-hkr-sut"
    },
    spec: {
      selector: {
        matchLabels: {
          app: appName,
          "ecoscape/node": locationLabel
        }
      },
      replicas: replicas,
      template: {
        metadata: {
          labels: {
            app: appName,
            "ecoscape/node": locationLabel
          }
        },
        spec: {
          nodeSelector: {
            "kubernetes.io/hostname": locationLabel
          },
          containers: [
            {
              name: appName,
              image: "hendrikreiter/object_classifier",
              imagePullPolicy: "IfNotPresent",
              ports: [
                {
                  containerPort: 80,
                  name: "web"
                },
                {
                  containerPort: 5000,
                  name: "metrics"
                }
              ],
              env: [
                {
                  name: "BOOTSTRAP_SERVER",
                  value: bootstrapServer
                },
                {
                  name: "TOPICS",
                  value: topic
                },
                {
                  name: "MODEL_DEPTH",
                  value: modelDepth
                }
              ],
              resources: {
                limits: {
                  memory: memory,
                  cpu: cpu
                },
                requests: {
                  memory: memory,
                  cpu: cpu
                }
              }
            }
          ]
        }
      }
    }
  }
}