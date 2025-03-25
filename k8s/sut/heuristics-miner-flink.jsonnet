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
    bootstrapServer: "minikube:1234",
    inputTopic: "input"
  }
)
{
  apiVersion: "apps/v1",
  kind: "Job",
  metadata: {
    name: name,
    namespace: externalParameter.namespace,
    labels: {
      app: name
    }
  },
  spec: {
    ttlSecondsAfterFinished: 60,
    backoffLimit: 3,
    template: {
      metadata: {
        labels: {
          app: name
        }
      },
      spec: {
        restartPolicy: "Never",
        containers: [
          {
            name: name,
            image: "hendrikreiter/process-mining-flink:0.1.0",
            imagePullPolicy: "Always",
            command: [
              "/bin/bash",
              "-c",
              "flink run -d -m flink-session-jobmanager:8081 -py /app/flink_pipeline_main.py"
            ],
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
                value: std.toString(definition.parallelism)
              },
              {
                name: 'PATH_TO_CONNECT_JAR',
                value: "/app"
              },
              {
                name: 'SAMPLE_SIZE',
                value: std.toString(definition.sampleSize)
              },
              {
                name: 'BATCH_SIZE',
                value: std.toString(definition.batchSize)
              },
              {
                name: 'AND_THRESHOLD',
                value: std.toString(definition.andThreshold)
              },
              {
                name: 'DEPENDENCY_THRESHOLD',
                value: std.toString(definition.dependencyThreshold)
              },
            ],
          }
        ]
      }
    }
  }
}
