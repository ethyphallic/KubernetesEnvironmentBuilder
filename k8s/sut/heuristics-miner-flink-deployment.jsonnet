{
  heuristicsMinerFlinkDeployment(
    namespace,
    bootstrapServer,
    inputTopic,
    modelTopic,
    group,
    parallelism,
    bucketSize,
    andThreshold,
    dependencyThreshold,
    variant,
    jobManagerMemory,
    jobManagerCPU,
    taskManagerMemory,
    taskManagerCPU,
    taskManagerTaskSlots
  ):: 
  {
    apiVersion: "flink.apache.org/v1beta1",
    kind: "FlinkDeployment",
    metadata: {
      name: "heuristics-miner-flink"
    },
    spec: {
      image: "hendrikreiter/heuristics-miner-flink:0.0.2",
      imagePullPolicy: "Always",
      flinkVersion: "v1_17",
      flinkConfiguration: {
        "taskmanager.numberOfTaskSlots": taskManagerTaskSlots
      },
      serviceAccount: "flink",
      jobManager: {
        resource: {
          memory: jobManagerMemory,
          cpu: jobManagerCPU
        },
        podTemplate: {
          apiVersion: "v1",
          kind: "Pod",
          metadata: {
            name: "pod-template"
          },
          spec: {
            serviceAccount: "flink",
            containers: [
                {
                  name: "flink-main-container",
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
                    value: bucketSize
                  },
                  {
                    name: "PARALLELISM",
                    value: parallelism
                  },
                  {
                    name: "AND_THRESHOLD",
                    value: andThreshold
                  },
                  {
                    name: "DEPENDENCY_THRESHOLD",
                    value: dependencyThreshold
                  },
                  {
                    name: "GROUP",
                    value: group
                  },
                  {
                    name: "VARIANT",
                    value: "parallelized"
                  }
                 ]
                }
               ]
              }
            }
      },
      taskManager: {
        resource: {
          memory: taskManagerMemory,
          cpu: taskManagerCPU
        }
      },
      job: {
        jarURI: "local:///opt/flink/opt/flink-python-1.17.2.jar",
        entryClass: "org.apache.flink.client.python.PythonDriver",
        args: ["-pyclientexec", "/usr/bin/python3", "-py", "/app/flink_pipeline_main.py"],
        parallelism: parallelism,
        upgradeMode: "stateless"
      }
    }
  }
}