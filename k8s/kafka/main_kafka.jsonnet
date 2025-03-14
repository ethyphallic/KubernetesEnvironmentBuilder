local kafka = import 'kafka.jsonnet';
local kafkaTopic = import 'kafka-topic.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';
local build = import '../util/build-util.jsonnet';

function(global, config, path="kafka") (
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

    local topicManifests = build.iterateOver(
      definition = config.kafka.topics,
      buildFunction=kafkaTopic,
      externalParameter={
        clusterName: config.kafka.clusterName,
        namespace: global.kafkaNamespace
      },
    );

    buildManifest(path, "kafka-cluster", kafkaCluster)
    + buildManifest(path, "kafka-metrics-configmap", kafkaMetricsConfigMap)
    + buildManifest(path, "kafka-exporter-podmonitor", kafkaExporterPodMonitor)
    + buildManifest(path, "kafka-podmonitor", kafkaPodMonitor)
    + buildManifests(path, "topic", topicManifests)
)
