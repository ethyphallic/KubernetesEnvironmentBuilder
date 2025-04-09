local kafka = import 'kafka.jsonnet';
local kafkaMetricsConfigmap = import 'resources/kafka-metrics-configmap.jsonnet';
local kafkaTopic = import 'kafka-topic.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';
local buildManifestsFromMap = import '../util/build/build-manifests-from-map.jsonnet';
local kafkaUi = import 'resources/kafka-ui/kafka-ui.jsonnet';

function(context, path="kafka") (
    local kafkaClusterName = context.config.clusterName;
    local kafkaMetricsConfigMap = kafkaMetricsConfigmap(context.functions.kafkaNamespace);

    buildManifest(path, "kafka-metrics-configmap", kafkaMetricsConfigMap)
    + buildManifestsFromMap(
      path,
      "kafka-cluster",
      definition=context.config.data.kafka.cluster,
      externalParameter={
        namespace: context.functions.kafkaNamespace,
        host: context.config.context.cluster
      },
      buildFunction=kafka
    )
    + buildManifestsFromMap(
      path + "/topic",
      "topic",
      context.config.data.kafka.topics,
      buildFunction=kafkaTopic,
      externalParameter={
        namespace: context.functions.kafkaNamespace
      }
    )
    + buildManifests(
      path + "/ui",
      "kafka-ui",
      kafkaUi(namespace=context.functions.kafkaNamespace)
    )
)
