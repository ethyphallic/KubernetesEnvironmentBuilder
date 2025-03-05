{
  buildDataNode(
    appName,
    appLabel,
    bootstrapServer,
    topic,
    sendInterval="1",
    memory="128Mi",
    cpu="500m",
    keyStart=0
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
                },
                {
                  name: "KEY",
                  value: "%s-%s" %[keyStart,keyStart+20]
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