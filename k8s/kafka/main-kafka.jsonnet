local kafka = import 'kafka.jsonnet';
local kafkaMetricsConfigmap = import 'resources/kafka-metrics-configmap.jsonnet';
local kafkaTopic = import 'kafka-topic.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifestsFromMap = import '../util/build/build-manifests-from-map.jsonnet';

function(context, path="kafka") (
    local kafkaClusterName = context.config.clusterName;
    local kafkaMetricsConfigMap = kafkaMetricsConfigmap(context.functions.kafkaNamespace);

    buildManifest(path, "kafka-metrics-configmap", kafkaMetricsConfigMap)
    + buildManifestsFromMap(
      path,
      "kafka-cluster",
      definition=context.config.kafka.cluster,
      externalParameter={
        namespace: context.functions.kafkaNamespace,
        host: context.config.context.cluster
      },
      buildFunction=kafka
    )
    + buildManifestsFromMap(
      path,
      "topic",
      context.config.kafka.topics,
      buildFunction=kafkaTopic,
      externalParameter={
        clusterName: context.config.kafka.clusterName,
        namespace: context.functions.kafkaNamespace
      }
    )
)
