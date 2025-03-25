function(
    name,
    definition={
      replicas: 1,
      partitions: 1,
      cluster: "zone1"
    },
    externalParameter={
      namespace: "kafka"
    }
){
    apiVersion: "kafka.strimzi.io/v1beta2",
    kind: "KafkaTopic",
    metadata: {
        name: name,
        namespace: externalParameter.namespace,
        labels: {
            "strimzi.io/cluster": definition.cluster
        }
    },
    spec: {
        topicName: definition.name,
        partitions: std.get(definition, "partitions", 1),
        replicas: std.get(definition, "replicas", 1)
    }
}