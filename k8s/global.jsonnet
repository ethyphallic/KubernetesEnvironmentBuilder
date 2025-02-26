local config = import 'config.json';

{
    bootstrapServer: config.kafka.clusterName + "-kafka-bootstrap.kafka.svc:9092"
}