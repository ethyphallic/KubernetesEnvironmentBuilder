local load = import 'k8s/load.jsonnet';
local flink = import 'k8s/flink.jsonnet';
local kafka = import 'k8s/kafka.jsonnet';
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

local inputTopic = kafka.kafkaTopic(
    topicName=inputTopicName,
    clusterName=kafkaClusterName,
    partitions=10,
    replicas=1
);

local modelTopic = kafka.kafkaTopic(
    topicName=modelTopicName,
    clusterName=kafkaClusterName,
    partitions=1,
    replicas=1
);

local kafkaUi = kafka.kafkaUiValuesYaml(
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    bootstrapServer=bootstrapServer
);

local defDeployment = load.loadDefDeployment(
    namespace=kafkaNamespace,
);

local defBackendDeployment = load.loadBackendDeployment(
    namespace=kafkaNamespace,
    topic=inputTopicName,
    bootstrapServer=bootstrapServer
);

local defBackendService = load.loadBackendService(kafkaNamespace);

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

{
    "../build/kafka/kafka.json": kafkaDefinition,
    "../build/kafka/input-topic.json": inputTopic,
    "../build/kafka/model-topic.json": modelTopic,
    "../build/kafka-ui/values.json": kafkaUi,
    "../build/flink/flink-deployment.json": flinkDeployment,
    "../build/load/def-deployment.json": defDeployment,
    "../build/load/def-backend-deployment.json": defBackendDeployment,
    "../build/load/def-backend-service.json": defBackendService
}