local config = import 'config.json';

{
    bootstrapServer: config.kafka.clusterName + "-kafka-bootstrap.scalablemine-hkr-kafka.svc:9092"
}