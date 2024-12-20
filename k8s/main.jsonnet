local config = import '../config.json';
local kafkaMain = import 'kafka/main_kafka.jsonnet';
local loadMain = import 'kafka/main_load.jsonnet';
local infraMain = import 'kafka/main_infra.jsonnet';
local sutMain = import 'kafka/main_sut.jsonnet';

local kafka = import 'kafka/kafka.jsonnet';

local kafkaNamespace = "kafka";
local inputTopicName = "testi";
local modelTopicName = "model";
local kafkaClusterName = "power";



local modelTopic = kafka.kafkaTopic(
    topicName=modelTopicName,
    namespace=kafkaNamespace,
    clusterName=kafkaClusterName,
    partitions=1,
    replicas=1
);


{
    "build/kafka/input-topic.json": inputTopic,
    "build/kafka/model-topic.json": modelTopic,
} + kafkaMain + loadMain + infraMain + sutMain