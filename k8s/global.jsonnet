local config = import 'config.json';

{
    bootstrapServer: config.kafka.clusterName + "-kafka-bootstrap.scalablemine-stu208763-kafka.svc:9092"
}