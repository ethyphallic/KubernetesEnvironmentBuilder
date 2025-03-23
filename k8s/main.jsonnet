local clusterMain = import "cluster/main-cluster.jsonnet";
local kafka = import 'kafka/main-kafka.jsonnet';
local load = import 'load/main-load.jsonnet';
local infraMain = import 'infra/main-infra.jsonnet';
local sutMain = import 'sut/main-sut.jsonnet';
local monitorMain = import 'monitor/main-monitor.jsonnet';
local global = import 'global.jsonnet';
local context = import 'context.jsonnet';

clusterMain
+ kafka(context)
+ load(context)
+ infraMain(context)
+ sutMain(context)
#+ monitorMain