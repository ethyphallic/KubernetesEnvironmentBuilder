local load = import 'load.jsonnet';
local loadConfig = import 'load-cm.jsonnet';
local loadConfigDataSource = import 'datasource/assembly-line.jsonnet';
local config = import '../../config.json';
local global = import '../../global.jsonnet';
local kafkaTopic = import '../kafka/kafka-topic.jsonnet';
local imageProducer = import 'image-producer.jsonnet';
local build = import '../util/build-util.jsonnet';

local inputTopicName = config.load.inputTopic;
local loadNamespace = "load";

local inputTopic = kafkaTopic.kafkaTopic(
    topicName=inputTopicName,
);

local defDeployment = load.loadDefDeployment();

local defBackendDeployment = load.loadBackendDeployment(
    topic=inputTopicName
);

local defBackendService = load.loadBackendService();
local loadConfigmap = loadConfig.simulation(intensity=config.load.intensity, genTimeframesTilStart=100);
local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %["load-backend", loadNamespace], timeframe=1000);

local image_producer = imageProducer.buildFromConfig(config.load.data, global.bootstrapServer, kafkaTopic);

local output = {
    "build/load/def-deployment.json": defDeployment,
    "build/load/def-backend-deployment.json": defBackendDeployment,
    "build/load/def-backend-service.json": defBackendService,
    "build/load/load/load-config.json": loadConfigmap,
    "build/load/sink/sink-config.json": sinkConfigmap
} + build.buildManifests("load", "data", image_producer);

output + { ["build/load/datasource/%s.json" %[std.stripChars(datasource.name, "<>")]] : datasource for datasource in loadConfigDataSource.all()}
