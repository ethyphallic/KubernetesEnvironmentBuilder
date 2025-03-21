local flink = import 'flink.jsonnet';
local objectClassifier = import 'object_classifier.jsonnet';
local astrolabe = import 'astrolabe.jsonnet';
local build = import '../util/build-util.jsonnet';
local buildManifestsFromMap = import '../util/build/build-manifests-from-map.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(config)
{
  flink(definition): buildManifest(
    path="sut",
    manifestName="flink",
    manifest=flink(
      name="flink",
      definition=definition,
      externalParameter={
        namespace: config.global.sutNamespace,
        inputTopic: config.global.inputTopic,
        bootstrapServer: config.global.bootstrapServer
      }
    )
  ),
  objectClassifier(definition): buildManifestsFromMap(
    path="sut",
    manifestName="object-classifier",
    definition = definition,
    externalParameter={
      bootstrapServer: config.global.bootstrapServer,
      topic: config.global.inputTopic
    },
    buildFunction=objectClassifier
  ),
  astrolabe(definition):
    buildManifest(
      path="sut",
      manifestName="astrolabe",
      manifest=astrolabe(
        definition=definition,
        externalParameter={
          bootstrapServer: config.global.bootstrapServer,
          inputTopic: config.global.inputTopic,
          namespace: config.global.sutNamespace,
          prometheusHostName: config.config.context.cluster
       }
    )
  )
}