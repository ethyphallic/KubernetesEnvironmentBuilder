local clusterMain = import "cluster/main_cluster.jsonnet";
local kafka = import 'kafka/main_kafka.jsonnet';
local load = import 'load/main_load.jsonnet';
local infraMain = import 'infra/main_infra.jsonnet';
local sutMain = import 'sut/main_sut.jsonnet';
local monitorMain = import 'monitor/main_monitor.jsonnet';
local global = import 'global.jsonnet';
local config = import 'config.jsonnet';

//clusterMain
kafka(global.global, config)
+ load(global.global, config.load)
+ infraMain(global, config)
+ sutMain
//+ monitorMain