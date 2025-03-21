function(
  name="name",
  index=0,
  definition={
    location: "",
    sendInterval: "1",
    memory: "128Mi",
    cpu: "500m",
  },
  externalParameters={
    bootstrapServer: "",
    inputTopic: ""
  }
) {
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: name,
    namespace: "scalablemine-hkr-load"
  },
  spec: {
    selector: {
      matchLabels: {
        "ecoscape/node": definition.location
      }
    },
    replicas: 1,
    template: {
      metadata: {
        labels: {
          "ecoscape/node": definition.location
        }
      },
      spec: {
        nodeSelector: {
          "kubernetes.io/hostname": definition.location
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
            name: name,
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
                value: externalParameters.bootstrapServer
              },
              {
                name: "TOPIC",
                value: externalParameters.inputTopic
              },
              {
                name: "SEND_INTERVAL",
                value: definition.intensity
              },
              {
                name: "KEY",
                value: "%s-%s" %[index,index+20]
              }
            ],
            resources: {
              limits: {
                memory: "1Gi",
                cpu: 1
              },
              requests: {
                memory: "1Gi",
                cpu: 1
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