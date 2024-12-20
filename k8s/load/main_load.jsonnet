local load = import 'load.jsonnet';
local loadConfig = import 'load-cm.jsonnet';
local loadConfigDataSource = import 'datasource/assembly-line.jsonnet';
local config = import '../../config';
local kafkaTopic = import '../kafka/kafka-topic.jsonnet';


local inputTopic = kafka.kafkaTopic(
    topicName=inputTopicName,
);

local defDeployment = load.loadDefDeployment(
    namespace=kafkaNamespace
);

local defBackendDeployment = load.loadBackendDeployment(
    namespace=kafkaNamespace,
    topic=inputTopicName,
    bootstrapServer=bootstrapServer
);

local defBackendService = load.loadBackendService(kafkaNamespace);

local loadConfigmap = loadConfig.simulation(intensity=config.load.intensity, genTimeframesTilStart=100);
local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %["load-backend", kafkaNamespace], timeframe=1000);

#local startSensor = loadConfigDataSource.startSensor();
#local goodsDelivery = loadConfigDataSource.goodsDelivery();
#local materialPreparation = loadConfigDataSource.materialPreparation();
#local assemblyLineSetup = loadConfigDataSource.assemblyLineSetup();
#local assembling = loadConfigDataSource.assembling();
#local qualityControl = loadConfigDataSource.qualityControl();
#local packaging = loadConfigDataSource.packaging();
#local shipping = loadConfigDataSource.shipping();
#"build/load/config/assemblyline/00-start.json": startSensor,
#"build/load/config/assemblyline/01-goods-delivery.json": goodsDelivery,
#"build/load/config/assemblyline/02-materialPreparation.json": materialPreparation,
#"build/load/config/assemblyline/03-assemblyLineSetup.json": assemblyLineSetup,
#"build/load/config/assemblyline/04-assembling.json": assembling,
#"build/load/config/assemblyline/05-quality-control.json": qualityControl,
#"build/load/config/assemblyline/06-packaging.json": packaging,
#"build/load/config/assemblyline/07-shipping.json": shipping]


local output = {
    "build/load/input-topic": inputTopic,
    "build/load/def-deployment.json": defDeployment,
    "build/load/def-backend-deployment.json": defBackendDeployment,
    "build/load/def-backend-service.json": defBackendService,
    "build/load/config/load-config.json": loadConfigmap,
    "build/load/config/sink-config.json": sinkConfigmap
};

output + { ["build/load/config/assemblyline/%s" %[datasource]] : datasource for datasource in loadConfigDataSource.all()}

