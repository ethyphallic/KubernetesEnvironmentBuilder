{
  heuristicsMinerFlinkJob(
    namespace,
    bootstrapServer,
    inputTopic,
    modelTopic,
    group,
    parallelism,
    bucketSize,
    andThreshold,
    dependencyThreshold,
    variant
  ):: 
  {
    apiVersion: "batch/v1",
    kind: "Job",
    metadata: {
      name: "heuristics-miner-job-submitter",
      namespace: namespace
    },
    spec: {
      ttlSecondsAfterFinished: 60,
      backoffLimit: 3,
      template: {
        spec: {
          restartPolicy: "Never",
          containers: [
            {
              name: "flink-job-submitter",
              image: "hendrikreiter/heuristics-miner-flink:0.0.2",
              imagePullPolicy: "Always",
              command: [
                "/bin/bash", 
                "-c",
                "flink run -d -m flink-session-jobmanager:8081 -py /app/flink_pipeline_main.py"
              ],
              env: [
                {
                  name: "BOOTSTRAP_SERVER",
                  value: bootstrapServer
                },
                {
                  name: "PATH_TO_CONNECT_JAR",
                  value: "/app"
                },
                {
                  name: "INPUT_TOPIC",
                  value: inputTopic
                },
                {
                  name: "MODEL_TOPIC",
                  value: modelTopic
                },
                {
                  name: "BUCKET_SIZE",
                  value: std.toString(bucketSize)
                },
                {
                  name: "PARALLELISM",
                  value: std.toString(parallelism)
                },
                {
                  name: "AND_THRESHOLD",
                  value: std.toString(andThreshold)
                },
                {
                  name: "DEPENDENCY_THRESHOLD",
                  value: std.toString(dependencyThreshold)
                },
                {
                  name: "GROUP",
                  value: group
                },
                {
                  name: "VARIANT",
                  value: variant
                }
              ]
            }
          ]
        }
      }
    }
  }
}