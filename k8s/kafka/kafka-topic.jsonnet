function(
    name,
    definition={
      replicas: 1,
      partitions: 1
    },
    externalParameter={
      namespace: "kafka",
      clusterName: "cluster"
    }
){
    apiVersion: "kafka.strimzi.io/v1beta2",
    kind: "KafkaTopic",
    metadata: {
        name: name,
        namespace: externalParameter.namespace,
        labels: {
            "strimzi.io/cluster": externalParameter.clusterName
        }
    },
    spec: {
        partitions: std.get(definition, "partitions", 1),
        replicas: std.get(definition, "replicas", 1)
    }
}