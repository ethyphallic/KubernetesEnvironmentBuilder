local kafkaTopic = import '../kafka/kafka-topic.jsonnet';
local imageProducer = import 'image-producer.jsonnet';
local loadRegistry = import 'load-registry.jsonnet';

function(context, path="load", key="load") (
    local loadConfig = std.get(context.config, key);
    std.get(loadRegistry(context), loadConfig.loadType)(path, loadConfig)
)