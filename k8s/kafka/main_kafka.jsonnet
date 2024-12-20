local kafka = import 'kafka.jsonnet';

local kafkaCluster = kafka.kafkaCluster(
    clusterName="kafkaClusterName",
    brokerReplicas=2,
    zookeeperReplicas=1
);

local kafkaExporterPodMonitor = kafka.kafkaExporterPodMonitor(
    clusterName=kafkaClusterName,
    namespace=kafkaNamespace
);

local kafkaPodMonitor = kafka.kafkaPodMonitor(
    clusterName=kafkaClusterName,
    namespace=kafkaNamespace
);

local kafkaMetricsConfigMap = kafka.kafkaMetricsConfigmap(kafkaNamespace);

local kafkaUi = kafka.kafkaUiValuesYaml(
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    bootstrapServer=bootstrapServer
);

{
    "build/kafka/kafka.json": kafkaCluster,
    "build/kafka/kafka-metrics-configmap.json": kafkaMetricsConfigMap,
    "build/kafka/kafka-exporter-podmonitor.json": kafkaExporterPodMonitor,
    "build/kafka/kafka-podmonitor.json": kafkaPodMonitor,
    "build/kafka/values.json": kafkaUi
}