function(
    name,
    definition={
        kafkaCluster: "zone1"
    },
    externalParameter={
        namespace: "",
        bootstrapServer: function(a)a
    }
    )
{
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: name,
    namespace: externalParameter.namespace
  },
  spec: {
    selector: {
      matchLabels: {
        app: "process-monitor",
      }
    },
    replicas: 1,
    template: {
      metadata: {
        labels: {
          app: "process-monitor",
        }
      },
      spec: {
        containers: [
          {
            name: name,
            image: "hendrikreiter/process-monitor:0.1.0",
            imagePullPolicy: "Always",
            ports: [
              {
                containerPort: 5000,
                name: "metrics"
              }
            ],
            env: [
              {
                name: "BOOTSTRAP_SERVER",
                value: externalParameter.bootstrapServer(definition.kafkaCluster)
              },
              {
                name: "REPORTER_WINDOW_SIZE",
                value: "1000"
              }
            ],
            resources: {
              limits: {
                memory: "500Mi",
                cpu: "250m"
              },
            }
          }
        ]
      }
    }
  }
}