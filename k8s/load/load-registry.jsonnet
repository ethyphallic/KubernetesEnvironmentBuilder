local imageProducer = import 'image-producer.jsonnet';
local eventFactory = import 'event-factory/event-factory-main.jsonnet';

function(config)
{
  eventFactory(definition): eventFactory(definition, config),
  imageProducer(definition): imageProducer.build(definition, config)
}