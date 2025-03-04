local config = import '../config.json';

{
    bootstrapServer: config.kafka.clusterName + "-kafka-bootstrap." + config.kafka.namespace + ".svc:9092"
}