local kafkaTopic = import 'kafka/kafka-topic.jsonnet';
local buildManifestsFromMap = import 'util/build/build-manifests-from-map.jsonnet';

function(config)
{
    bootstrapServer(clusterName)::
    //if std.contains(config.clusterName, clusterName) then
    // TODO add proper error handling
    "%s-kafka-bootstrap.%s.svc:9092" %[clusterName, $.kafkaNamespace],
    //else error "Invalid cluster name specified",
    kafkaNamespace: "%s%s" %[config.context.prefix, "kafka"],
    loadNamespace: "%s%s" %[config.context.prefix, "load"],
    infraNamespace: "%s%s" %[config.context.prefix, "infra"],
    sutNamespace: "%s%s" %[config.context.prefix, "sut"],
    monitorNamespace: "%s%s" %[config.context.prefix, "monitor"],
    inputTopic: "input",
    createKafkaTopic(path, topics): buildManifestsFromMap(
      path,
      "topic",
      topics,
      buildFunction=kafkaTopic,
      externalParameter={
        namespace: $.kafkaNamespace
      }
    )
}