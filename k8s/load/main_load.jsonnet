local kafkaTopic = import '../kafka/kafka-topic.jsonnet';
local imageProducer = import 'image-producer.jsonnet';
local loadRegistry = import 'load-registry.jsonnet';

function(global, config) (
    std.get(loadRegistry(global), config.loadType)(config)
)