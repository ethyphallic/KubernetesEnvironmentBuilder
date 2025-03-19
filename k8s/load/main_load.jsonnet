local load = import 'load.jsonnet';
local loadConfig = import 'load-cm.jsonnet';
local loadConfigDataSource = import 'datasource/assembly-line.jsonnet';
local config = import '../../config.json';
local global = import '../global.jsonnet';
local kafkaTopic = import '../kafka/kafka-topic.jsonnet';

local inputTopicName = config.load.inputTopic;
local prefix = config.context.prefix;
local defaultNamespace = config.load.namespace;
local namespace = if prefix != null && prefix != "" then prefix + "-" + defaultNamespace else defaultNamespace;

local inputTopic = kafkaTopic.kafkaTopic(
    topicName=inputTopicName,
    namespace=namespace
);

local defDeployment = load.loadDefDeployment(
    namespace=namespace
);

local defBackendDeployment = load.loadBackendDeployment(
    namespace=namespace,
    topic=inputTopicName
);

local defBackendService = load.loadBackendService(
    namespace=namespace
);

local loadConfigmap = loadConfig.simulation(intensity=config.load.intensity, genTimeframesTilStart=100);
local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %["load-backend", namespace], timeframe=1000);

local output = {
    "build/load/def-deployment.json": defDeployment,
    "build/load/def-backend-deployment.json": defBackendDeployment,
    "build/load/def-backend-service.json": defBackendService,
    "build/load/load/load-config.json": loadConfigmap,
    "build/load/sink/sink-config.json": sinkConfigmap
};

output + { ["build/load/datasource/%s.json" %[std.stripChars(datasource.name, "<>")]] : datasource for datasource in loadConfigDataSource.all()}
