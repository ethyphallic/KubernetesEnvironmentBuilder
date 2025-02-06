{
  build(appName, appLabel, bootstrapServer, topic, modelDepth, replicas, memory="128Mi", cpu="500m"):: {
    apiVersion: "apps/v1",
    kind: "StatefulSet",
    metadata: {
      name: appName,
      namespace: "sut"
    },
    spec: {
      selector: {
        matchLabels: {
          app: appLabel
        }
      },
      replicas: replicas,
      template: {
        metadata: {
          labels: {
            app: appLabel
          }
        },
        spec: {
          containers: [
            {
              name: appName,
              image: "hendrikreiter/object_classifier",
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
  },
  buildDataNode(
    appName,
    appLabel,
    bootstrapServer,
    topic,
    sendInterval="1",
    memory="128Mi",
    cpu="500m"
  ):: {
    apiVersion: "apps/v1",
    kind: "StatefulSet",
    metadata: {
      name: appName,
      namespace: "load"
    },
    spec: {
      selector: {
        matchLabels: {
          "ecoscape/node": appLabel
        }
      },
      replicas: 1,
      template: {
        metadata: {
          labels: {
            "ecoscape/node": appLabel
          }
        },
        spec: {
          containers: [
            {
              name: appName,
              image: "hendrikreiter/image_producer",
              ports: [
                {
                  containerPort: 80,
                  name: "web"
                }
              ],
              env: [
                {
                  name: "BOOTSTRAP_SERVER",
                  value: bootstrapServer
                },
                {
                  name: "TOPIC",
                  value: topic
                },
                {
                  name: "SEND_INTERVAL",
                  value: sendInterval
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