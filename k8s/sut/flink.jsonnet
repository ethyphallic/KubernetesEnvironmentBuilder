local appName = "heuristics-miner-flink";
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(
  name,
  definition={
    modelTopic: "model",
    group: "group",
    parallelism: 1,
    sampleSize: 20,
    batchSize: 10,
    andThreshold: 0.5,
    dependencyThreshold: 0.5
  },
  externalParameter={
    namespace: "sut",
    bootstrapServer: "minikube:123",
    inputTopic: "input"
  }
)
{
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: name,
    namespace: externalParameter.namespace,
    labels: {
      app: name
    }
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: name
      }
    },
    template: {
      metadata: {
        labels: {
          app: name
        }
      },
      spec: {
        containers: [
          {
            name: name,
            image: "hendrikreiter/process-mining-flink:0.1.0",
            imagePullPolicy: "Always",
            env: [
              {
                 name: "BOOTSTRAP_SERVER",
                 value: externalParameter.bootstrapServer(definition.kafkaCluster)
              },
              {
                 name: "INPUT_TOPIC",
                 value: externalParameter.inputTopic
              },
              {
                  name: "MODEL_TOPIC",
                  value: definition.modelTopic
              },
              {
                  name: "GROUP",
                  value: definition.group
              },
              {
                  name: "PARALLELISM",
                  value: definition.parallelism
              },
              {
                  name: 'PATH_TO_CONNECT_JAR',
                  value: "/app"
              },
              {
                  name: 'SAMPLE_SIZE',
                  value: definition.sampleSize
              },
              {
                  name: 'BATCH_SIZE',
                  value: definition.batchSize
              },
              {
                  name: 'AND_THRESHOLD',
                  value: definition.andThreshold
              },
              {
                  name: 'DEPENDENCY_THRESHOLD',
                  value: definition.dependencyThreshold
              },
            ],
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
}
