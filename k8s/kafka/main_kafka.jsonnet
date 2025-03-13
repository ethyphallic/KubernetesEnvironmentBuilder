local kafka = import 'kafka.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';
local kafkaTopic = import 'kafka-topic.jsonnet';

local kafkaClusterName = config.kafka.clusterName;

local kafkaCluster = kafka.kafkaCluster(
    clusterName=kafkaClusterName,
    brokerReplicas=config.kafka.brokerReplicas,
    zookeeperReplicas=config.kafka.zookeeperReplicas,
    namespace=global.kafkaNamespace,
    host=config.context.cluster
);

local kafkaExporterPodMonitor = kafka.kafkaExporterPodMonitor(
    clusterName=kafkaClusterName,
    namespace=global.kafkaNamespace
);

local kafkaPodMonitor = kafka.kafkaPodMonitor(
    clusterName=kafkaClusterName,
    namespace=global.kafkaNamespace
);

local kafkaMetricsConfigMap = kafka.kafkaMetricsConfigmap(global.kafkaNamespace);

{
    "build/kafka/kafka.json": kafkaCluster,
    "build/kafka/kafka-metrics-configmap.json": kafkaMetricsConfigMap,
    "build/kafka/kafka-exporter-podmonitor.json": kafkaExporterPodMonitor,
    "build/kafka/kafka-podmonitor.json": kafkaPodMonitor,
} + { ["build/kafka/%s-topic.json" %[topic.name]] : kafkaTopic.kafkaTopic(namespace=global.kafkaNamespace, topicName=topic.name) for topic in config.kafka.topics}