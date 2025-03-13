local config = import '../config.json';

{
    bootstrapServer: "%s-kafka-bootstrap.%s.svc:9092" %[config.kafka.clusterName, $.kafkaNamespace],
    kafkaNamespace: "%s-%s" %[config.context.prefix, "kafka"],
    loadNamespace: "%s-%s" %[config.context.prefix, "load"],
    infraNamespace: "%s-%s" %[config.context.prefix, "infra"],
    sutNamespace: "%s-%s" %[config.context.prefix, "sut"],
    monitorNamespace: "%s-%s" %[config.context.prefix, "monitor"],
}