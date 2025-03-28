local imageProducer = import 'image-producer.jsonnet';
local eventFactory = import 'event-factory/event-factory-main.jsonnet';
local buildManifestsFromMapWithIndex = import '../util/build/build-manifests-from-map-with-index.jsonnet';

function(context)
{
  eventFactory(definition): eventFactory(
    definition,
    externalParameters={
      namespace: context.functions.loadNamespace,
      bootstrapServer: context.functions.bootstrapServer
    }
  ),
  imageProducer(definition):
    buildManifestsFromMapWithIndex(
      path="load",
      manifestName="image-producer",
      buildFunction=imageProducer,
      definition=definition.load,
      externalParameters={
        inputTopic: context.functions.inputTopic,
        bootstrapServer: context.functions.bootstrapServer
      }
    )
}