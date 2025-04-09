local dataRegistry = import 'data-registry.jsonnet';

function(context, path="kafka", key="kafka") (
    local kafkaConfig = std.get(context.config.data, key);
    std.get(dataRegistry(context), kafkaConfig.dataType)(path, kafkaConfig)
)