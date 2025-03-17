local flink = import 'flink.jsonnet';
local objectClassifier = import 'object_classifier.jsonnet';
local build = import '../util/build-util.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';

function(config)
{
  flink(definition): flink.buildFromConfig(
    config=definition,
    inputTopic=config.global.inputTopic,
    bootstrapServer=config.global.bootstrapServer
  ),
  objectClassifier(definition): buildManifests("sut", "object-classifier", build.iterateOver(
    definition = definition,
    externalParameter={
      bootstrapServer: config.global.bootstrapServer,
      topic: config.global.inputTopic
    },
    buildFunction=objectClassifier
  ))
}