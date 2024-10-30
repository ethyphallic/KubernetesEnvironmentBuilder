{
  kafkaCluster(clusterName, brokerReplicas, zookeeperReplicas):: {
    kind: "Kafka",
    apiVersion: "kafka.strimzi.io/v1beta2",
    metadata: {
      name: clusterName,
      namespace: "kafka"
    },
    spec: {
      entityOperator: {
        topicOperator: {},
        userOperator: {}
      },
      kafka: {
        replicas: brokerReplicas,
        config: {
          "default.replication.factor": 3,
          "inter.broker.protocol.version": "3.8",
          "min.insync.replicas": 2,
          "offsets.topic.replication.factor": 3,
          "transaction.state.log.min.isr": 2,
          "transaction.state.log.replication.factor": 3
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
                  advertisedHost: "minikube",
                  broker: i
                }
                for i in std.range(0,brokerReplicas-1)
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
  },
  kafkaTopic(topicName, clusterName, partitions, replicas):: {
    apiVersion: "kafka.strimzi.io/v1beta2",
    kind: "KafkaTopic",
    metadata: {
        name: topicName,
        labels: {
            "strimzi.io/cluster": clusterName
        }
    },
    spec: {
        partitions: partitions,
        replicas: replicas
    }
  },
  kafkaUiValuesYaml(namespace, clusterName, bootstrapServer):: {
    namespace: namespace,
    service: {
      type: "NodePort"
    },
    yamlApplicationConfig: {
      kafka: {
        clusters: [
          {
            name: clusterName,
            bootstrapServers: bootstrapServer
          }
        ]
      },
      auth: {
        type: "disabled"
      },
      management: {
        health: {
          ldap: {
            enabled: false
          }
        }
      }
    }
  },
  kafkaExporterPodMonitor(clusterName, namespace):: {
    apiVersion: "monitoring.coreos.com/v1",
    kind: "PodMonitor",
    metadata: {
      name: clusterName + "-kafka-exporter-podmonitor",
      namespace: namespace,
      labels: {
        release: "prometheus"
      }
    },
    spec: {
      selector: {
        matchLabels: {
          "strimzi.io/name": clusterName + "-kafka-exporter"
        }
      },
      podMetricsEndpoints: [
        {
          path: "/metrics",
          port: "tcp-prometheus"
        }
      ]
    }
  },
  kafkaPodMonitor(clusterName, namespace):: {
    apiVersion: "monitoring.coreos.com/v1",
    kind: "PodMonitor",
    metadata: {
      name: clusterName + "-kafka-resources-metrics",
      namespace: namespace,
      labels: {
        release: "prometheus"
      }
    },
    spec: {
      selector: {
        matchLabels: {
          "strimzi.io/name": clusterName + "-kafka"
        }
      },
      podMetricsEndpoints: [
        {
          path: "/metrics",
          port: "tcp-prometheus"
        }
      ]
    }
  }
}