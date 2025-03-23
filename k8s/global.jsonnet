local config = import 'config.jsonnet';

{
    config: config,
    global: {
        bootstrapServer(clusterName)::
        //if std.contains(config.clusterName, clusterName) then
        // TODO add proper error handling
        "%s-kafka-bootstrap.%s.svc:9092" %[clusterName, $.global.kafkaNamespace],
        //else error "Invalid cluster name specified",
        kafkaNamespace: "%s-%s" %[config.context.prefix, "kafka"],
        loadNamespace: "%s-%s" %[config.context.prefix, "load"],
        infraNamespace: "%s-%s" %[config.context.prefix, "infra"],
        sutNamespace: "%s-%s" %[config.context.prefix, "sut"],
        monitorNamespace: "%s-%s" %[config.context.prefix, "monitor"],
        inputTopic: "input"
    }
}