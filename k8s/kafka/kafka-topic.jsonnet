local config = import '../../config.json';

{
    kafkaTopic(namespace, topicName, partitions=3, replicas=1):: {
        apiVersion: "kafka.strimzi.io/v1beta2",
        kind: "KafkaTopic",
        metadata: {
            name: topicName,
            namespace: namespace,
            labels: {
                "strimzi.io/cluster": config.kafka.clusterName
            }
        },
        spec: {
            partitions: partitions,
            replicas: replicas
        }
    }
}