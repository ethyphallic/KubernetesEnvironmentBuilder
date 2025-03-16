local flink = import 'flink.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';
local sutConfig = import '../../sut-config.json';
local worker_node_builder = import 'object_classifier.jsonnet';
local topic_name = "dog-input";
local build = import '../util/build-util.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';

local sut = config.sut;
local bootstrapServer = global.global.bootstrapServer;

local flinkDeployment = flink.buildFromConfig(
    config=std.get(sutConfig, "flink"),
    inputTopic=config.load.inputTopic,
    bootstrapServer=bootstrapServer
);

local objectClassifierNodes = build.iterateOver(
  definition = std.get(sutConfig, "objectClassifier"),
  externalParameter={
    bootstrapServer: bootstrapServer,
    topic: topic_name
  },
  buildFunction=worker_node_builder.build
);

if sut == "flink" then buildManifest("sut", "flink", flinkDeployment)
else if sut == "objectClassifier" then buildManifests("sut", "object-classifier", objectClassifierNodes)
else error "System under test not found. Is there a typo?"