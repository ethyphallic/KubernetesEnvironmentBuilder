local kafka = import 'kafka.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';
local kafkaTopic = import 'kafka-topic.jsonnet';

local kafkaClusterName = config.kafka.clusterName;
local prefix = config.context.prefix;
local defaultNamespace = config.kafka.namespace;
local namespace = if prefix != null && prefix != "" then prefix + "-" + defaultNamespace else defaultNamespace;

local kafkaCluster = kafka.kafkaCluster(
    clusterName=kafkaClusterName,
    brokerReplicas=config.kafka.brokerReplicas,
    zookeeperReplicas=config.kafka.zookeeperReplicas,
    namespace=namespace
);

local kafkaExporterPodMonitor = kafka.kafkaExporterPodMonitor(
    clusterName=kafkaClusterName,
    namespace=namespace
);

local kafkaPodMonitor = kafka.kafkaPodMonitor(
    clusterName=kafkaClusterName,
    namespace=namespace
);

local kafkaMetricsConfigMap = kafka.kafkaMetricsConfigmap(namespace);

{
    "build/kafka/kafka.json": kafkaCluster,
    "build/kafka/kafka-metrics-configmap.json": kafkaMetricsConfigMap,
    "build/kafka/kafka-exporter-podmonitor.json": kafkaExporterPodMonitor,
    "build/kafka/kafka-podmonitor.json": kafkaPodMonitor,
} + { ["build/kafka/%s-topic.json" %[topic.name]] : kafkaTopic.kafkaTopic(namespace=namespace, topicName=topic.name) for topic in config.kafka.topics}