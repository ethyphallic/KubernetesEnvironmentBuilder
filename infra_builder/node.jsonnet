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
      namespace: "scalablemine-hkr-load"
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
          nodeSelector: {
            "kubernetes.io/hostname": appLabel
          },
          initContainers: [
            {
              name: "copy",
              image: "hendrikreiter/dog-test-images",
              command: [
                "/bin/sh",
                "-c",
                "cp -r /images/ /image"
              ],
              volumeMounts: [
                {
                  name: "image",
                  mountPath: "/image"
                },
              ]
            }
          ],
          containers: [
            {
              name: appName,
              image: "hendrikreiter/image_producer",
              imagePullPolicy: "IfNotPresent",
              ports: [
                {
                  containerPort: 80,
                  name: "web"
                }
              ],
              volumeMounts: [
                {
                  mountPath: "/Images",
                  name: "image",
                  readOnly: true
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
          ],
          volumes: [
            {
              name: "image",
              emptyDir: {
                sizeLimit: "1Gi"
              }
            }
          ]
        }
      }
    }
  }
}