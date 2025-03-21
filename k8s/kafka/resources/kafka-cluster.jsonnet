function(clusterName, brokerReplicas, zookeeperReplicas, namespace, host) {
  kind: "Kafka",
  apiVersion: "kafka.strimzi.io/v1beta2",
  metadata: {
    name: clusterName,
    namespace: namespace
  },
  spec: {
    entityOperator: {
      topicOperator: {},
      userOperator: {}
    },
    kafka: {
      replicas: brokerReplicas,
      resources: {
        limits: {
          memory: "500Mi",
          cpu: "500m"
        }
      },
      config: {
        "auto.create.topics.enable": false,
        "default.replication.factor": std.min(brokerReplicas, 3),
        "inter.broker.protocol.version": "3.8",
        "min.insync.replicas": std.min(brokerReplicas, 2),
        "offsets.topic.replication.factor": std.min(brokerReplicas, 3),
        "transaction.state.log.min.isr": std.min(brokerReplicas, 2),
        "transaction.state.log.replication.factor": std.min(brokerReplicas, 3)
      },
      listeners: [
        {
          name: "plain",
          port: 9092,
          tls: false,
          type: "internal"
        },
        {
          name: "external",
          port: 9093,
          tls: false,
          type: "nodeport",
          configuration: {
            brokers: [
              {
                advertisedHost: host,
                broker: i
              }
              for i in std.range(0, brokerReplicas-1)
            ]
          }
        }
      ],
      metricsConfig: {
        type: "jmxPrometheusExporter",
        valueFrom: {
          configMapKeyRef: {
            name: "kafka-metrics",
            key: "kafka-metrics-config.yml"
          }
        }
      },
      storage: {
        type: "ephemeral"
      },
      version: "3.8.0"
    },
    zookeeper: {
      replicas: zookeeperReplicas,
      storage: {
        type: "ephemeral"
      }
    },
    kafkaExporter: {}
  }
}