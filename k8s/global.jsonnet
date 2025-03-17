local config = import 'config.jsonnet';

{
    config: config,
    global: {
        bootstrapServer: "%s-kafka-bootstrap.%s.svc:9092" %[config.kafka.clusterName, $.global.kafkaNamespace],
        kafkaNamespace: "%s-%s" %[config.context.prefix, "kafka"],
        loadNamespace: "%s-%s" %[config.context.prefix, "load"],
        infraNamespace: "%s-%s" %[config.context.prefix, "infra"],
        sutNamespace: "%s-%s" %[config.context.prefix, "sut"],
        monitorNamespace: "%s-%s" %[config.context.prefix, "monitor"],
        inputTopic: "input"
    }
}