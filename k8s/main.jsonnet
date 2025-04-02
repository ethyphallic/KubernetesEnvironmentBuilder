local clusterMain = import "cluster/main-cluster.jsonnet";
local kafka = import 'kafka/main-kafka.jsonnet';
local loadMain = import 'load/main-load.jsonnet';
local infraMain = import 'infra/main-infra.jsonnet';
local sutMain = import 'sut/main-sut.jsonnet';
local monitorMain = import 'monitor/main-monitor.jsonnet';
local global = import 'global.jsonnet';
local context = import 'context.jsonnet';

clusterMain(context)
+ kafka(context)
+ loadMain(context, "warmup", "warmup")
+ loadMain(context, "load", "load")
+ infraMain(context)
+ sutMain(context, "sut0", "sut0")
+ sutMain(context, "sut1", "sut1")
+ monitorMain(context)