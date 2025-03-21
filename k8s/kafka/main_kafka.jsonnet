local kafka = import 'kafka.jsonnet';
local kafkaMetricsConfigmap = import 'resources/kafka-metrics-configmap.jsonnet';
local kafkaTopic = import 'kafka-topic.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifestsFromMap = import '../util/build/build-manifests-from-map.jsonnet';

function(global, config, path="kafka") (
    local kafkaClusterName = config.clusterName;
    local kafkaMetricsConfigMap = kafkaMetricsConfigmap(global.global.kafkaNamespace);

    buildManifest(path, "kafka-metrics-configmap", kafkaMetricsConfigMap)
    + buildManifestsFromMap(
      path,
      "kafka-cluster",
      definition=config.cluster,
      externalParameter={
        namespace: global.global.kafkaNamespace,
        host: global.config.context.cluster
      },
      buildFunction=kafka
    )
    + buildManifestsFromMap(
      path,
      "topic",
      config.topics,
      buildFunction=kafkaTopic,
      externalParameter={
        clusterName: config.clusterName,
        namespace: global.global.kafkaNamespace
      }
    )
)
