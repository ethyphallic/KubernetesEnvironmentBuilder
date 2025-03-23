local kafkaTopic = import '../kafka/kafka-topic.jsonnet';
local imageProducer = import 'image-producer.jsonnet';
local loadRegistry = import 'load-registry.jsonnet';

function(context) (
    std.get(loadRegistry(context), context.config.load.loadType)(context.config.load)
)