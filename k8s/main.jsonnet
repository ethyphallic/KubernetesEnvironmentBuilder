local config = import '../config.json';
local kafkaMain = import 'kafka/main_kafka.jsonnet';
local loadMain = import 'load/main_load.jsonnet';
local infraMain = import 'infra/main_infra.jsonnet';
local sutMain = import 'sut/main_sut.jsonnet';
#local kafka = import 'kafka/kafka.jsonnet';

local kafkaNamespace = "kafka";
local inputTopicName = "testi";
local modelTopicName = "model";
local kafkaClusterName = "power";

kafkaMain + loadMain + infraMain + sutMain