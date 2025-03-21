local imageProducer = import 'image-producer.jsonnet';
local eventFactory = import 'event-factory/event-factory-main.jsonnet';
local buildManifestsFromMapWithIndex = import '../util/build/build-manifests-from-map-with-index.jsonnet';

function(config)
{
  eventFactory(definition): eventFactory(
    definition,
    externalParameters={
      namespace: config.global.loadNamespace,
      bootstrapServer: config.global.bootstrapServer
    }
  ),
  imageProducer(definition):
    buildManifestsFromMapWithIndex(
      path="load",
      manifestName="image-producer",
      buildFunction=imageProducer,
      definition=definition.load,
      externalParameters={
        inputTopic: config.global.inputTopic,
        bootstrapServer: config.global.bootstrapServer
      }
    )
}