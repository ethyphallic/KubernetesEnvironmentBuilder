local builder = import '../util/build-util.jsonnet';

function(
    name,
    definition={
      locationLabel: "node1",
      memory: "1Gi",
      cpu: "2",
      modelDepth: "101",
      replicas: 3
    },
    externalParameter={
      bootstrapServer: "minikube:1234",
      topicName:"input"
    }
)
{
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: name,
    namespace: "scalablemine-hkr-sut"
  },
  spec: {
    selector: {
      matchLabels: {
        app: name,
        "ecoscape/node": definition.locationLabel
      }
    },
    replicas: definition.replicas,
    template: {
      metadata: {
        labels: {
          app: name,
          "ecoscape/node": definition.locationLabel
        }
      },
      spec: {
        nodeSelector: {
          "kubernetes.io/hostname": definition.locationLabel
        },
        containers: [
          {
            name: name,
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
                value: externalParameter.bootstrapServer
              },
              {
                name: "TOPICS",
                value: externalParameter.topic
              },
              {
                name: "MODEL_DEPTH",
                value: definition.modelDepth
              }
            ],
            resources: {
              limits: {
                memory: definition.memory,
                cpu: definition.cpu
              },
              requests: {
                memory: definition.memory,
                cpu: definition.cpu
              }
            }
          }
        ]
      }
    }
  }
}