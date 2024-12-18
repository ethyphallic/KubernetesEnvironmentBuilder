local load = import 'k8s/load.jsonnet';
local flink = import 'k8s/flink.jsonnet';
local kafka = import 'k8s/kafka.jsonnet';
local loadConfig = import 'k8s/load-cm.jsonnet';
local podChoas = import 'k8s/chaos/pod-chaos.jsonnet';
local loadConfigDataSource = import 'k8s/datasource/assembly-line.jsonnet';
local loadBackendName = "load-backend";
local kafkaNamespace = "kafka";
local inputTopicName = "testi";
local modelTopicName = "model";
local kafkaClusterName = "power";

local bootstrapServer = kafkaClusterName + "-kafka-bootstrap:9092";

local kafkaDefinition = kafka.kafkaCluster(
    clusterName=kafkaClusterName,
    brokerReplicas=3,
    zookeeperReplicas=1
);

local kafkaExporterPodMonitor = kafka.kafkaExporterPodMonitor(
    clusterName=kafkaClusterName,
    namespace=kafkaNamespace
);

local kafkaPodMonitor = kafka.kafkaPodMonitor(
    clusterName=kafkaClusterName,
    namespace=kafkaNamespace
);

local inputTopic = kafka.kafkaTopic(
    topicName=inputTopicName,
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    partitions=10,
    replicas=1
);

local modelTopic = kafka.kafkaTopic(
    topicName=modelTopicName,
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    partitions=1,
    replicas=1
);

local kafkaMetricsConfigMap = kafka.kafkaMetricsConfigmap(kafkaNamespace);

local kafkaUi = kafka.kafkaUiValuesYaml(
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    bootstrapServer=bootstrapServer
);

local defDeployment = load.loadDefDeployment(
    namespace=kafkaNamespace
);

local defBackendDeployment = load.loadBackendDeployment(
    namespace=kafkaNamespace,
    topic=inputTopicName,
    bootstrapServer=bootstrapServer
);

local defBackendService = load.loadBackendService(loadBackendName, kafkaNamespace);

local flinkDeployment = flink.heuristicsMinerFlinkDeployment(
    namespace = kafkaNamespace,
    bootstrapServer = bootstrapServer,
    inputTopic = inputTopicName,
    modelTopic = modelTopicName,
    group = "heuristics-miner",
    parallelism = "1",
    sampleSize = "200",
    batchSize = "100",
    andThreshold = "0.5",
    dependencyThreshold = "0.5"
);

local loadConfigmap = loadConfig.simulation(genTimeframesTilStart=100);
local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %[loadBackendName, kafkaNamespace], timeframe=1000);
local startSensor = loadConfigDataSource.startSensor();
local goodsDelivery = loadConfigDataSource.goodsDelivery();
local materialPreparation = loadConfigDataSource.materialPreparation();
local assemblyLineSetup = loadConfigDataSource.assemblyLineSetup();
local assembling = loadConfigDataSource.assembling();
local qualityControl = loadConfigDataSource.qualityControl();
local packaging = loadConfigDataSource.packaging();
local shipping = loadConfigDataSource.shipping();

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=kafkaNamespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

{
    "../build/kafka/kafka.json": kafkaDefinition,
    "../build/kafka/kafka-metrics-configmap.json": kafkaMetricsConfigMap,
    "../build/kafka/kafka-exporter-podmonitor.json": kafkaExporterPodMonitor,
    "../build/kafka/kafka-podmonitor.json": kafkaPodMonitor,
    "../build/kafka/input-topic.json": inputTopic,
    "../build/kafka/model-topic.json": modelTopic,
    "../build/kafka-ui/values.json": kafkaUi,
    "../build/flink/flink-deployment.json": flinkDeployment,
    "../build/load/def-deployment.json": defDeployment,
    "../build/load/def-backend-deployment.json": defBackendDeployment,
    "../build/load/def-backend-service.json": defBackendService,
    "../build/load-config/load/load-config.json": loadConfigmap,
    "../build/load-config/sink/sink-config.json": sinkConfigmap,
    "../build/load-config/datasource/00-start.json": startSensor,
    "../build/load-config/datasource/01-goods-delivery.json": goodsDelivery,
    "../build/load-config/datasource/02-materialPreparation.json": materialPreparation,
    "../build/load-config/datasource/03-assemblyLineSetup.json": assemblyLineSetup,
    "../build/load-config/datasource/04-assembling.json": assembling,
    "../build/load-config/datasource/05-quality-control.json": qualityControl,
    "../build/load-config/datasource/06-packaging.json": packaging,
    "../build/load-config/datasource/07-shipping.json": shipping,
    "../build/chaos/pod-failure.json": podFailure
}