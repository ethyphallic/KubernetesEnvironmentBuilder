function(
  definition={
    appLabel: "app1",
    modelDepth: "101",
    cpu: "1",
    memory: "1Gi",
    nodeLabel: "kube1-1",
    actions: [
      {
        type: "replica",
        min: 5,
        max: 10
      }
    ],
    metrics: [
      {
        name: "latency",
        type: "prometheus",
        aggregation: "sum",
        query: "avg(latency)"
      }
    ],
    slos: [
      {
        metric: "latency",
        evaluation: "geq",
        threshold: 10,
        weight: 100
      }
    ],
    name: "astrolabe"
  },
  externalParameter={
    bootstrapServer: "minkube:1234",
    inputTopic: "input",
    prometheusHostName: "minikube",
    namespace: "sut",
  }
) {
  apiVersion: "astrolabe.github.com/v1",
  kind: "Astrolabe",
  metadata: {
    name: definition.name,
    namespace: externalParameter.namespace
  },
  spec: {
    jobs: [
      {
        selector: {
          matchLabels: {
            app: definition.appLabel
          }
        },
        template: {
          metadata: {
            name: "astrolabe-object-classifier",
            labels: {
              app: definition.appLabel
            }
          },
          spec: {
            containers: [
              {
                env: [
                  {
                    name: "BOOTSTRAP_SERVER",
                    value: externalParameter.bootstrapServer
                  },
                  {
                    name: "TOPICS",
                    value: externalParameter.inputTopic
                  },
                  {
                    name: "MODEL_DEPTH",
                    value: definition.modelDepth
                  }
                ],
                image: "hendrikreiter/object_classifier",
                imagePullPolicy: "Always",
                name: definition.appLabel,
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
                resources: {
                  limits: {
                    cpu: definition.cpu,
                    memory: definition.memory
                  },
                  requests: {
                    cpu: definition.cpu,
                    memory: definition.memory
                  }
                }
              }
            ],
            nodeSelector: {
              "kubernetes.io/hostname": "kube1-4"
            }
          }
        }
      }
    ],
    prometheus: {
      address: "http://%s" %[externalParameter.prometheusHostName],
      port: 30920
    },
    actions: definition.actions,
    metrics: definition.metrics,
    slos: definition.slos
  }
}
