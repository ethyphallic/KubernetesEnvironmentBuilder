local config = import '../../config.json';

{
    kafkaTopic(topicName, partitions=3, replicas=1):: {
        apiVersion: "kafka.strimzi.io/v1beta2",
        kind: "KafkaTopic",
        metadata: {
            name: topicName,
            namespace: "kafka",
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