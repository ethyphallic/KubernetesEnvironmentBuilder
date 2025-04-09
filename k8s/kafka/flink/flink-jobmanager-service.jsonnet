function(
    externalParameters={namespace: "data"}
) {
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: "flink-session-jobmanager",
    namespace: externalParameters.namespace,
  },
  spec: {
    ports: [
      {
        name: "rpc",
        port: 6123,
      },
      {
        name: "ui",
        port: 8081,
      },
    ],
    selector: {
      app: "flink",
      component: "jobmanager",
    },
  },
}