local clusterMain = import "cluster/main-cluster.jsonnet";
local kafkaMain = import 'kafka/main-kafka.jsonnet';
local sutMain = import 'sut/main-sut.jsonnet';
local loadMain = import 'load/main-load.jsonnet';
local infraMain = import 'infra/main-infra.jsonnet';
local monitorMain = import 'monitor/main-monitor.jsonnet';
local global = import 'global.jsonnet';
local context = import 'context.jsonnet';
local cpuStress = import 'infra/cpu-stressor.jsonnet';
local buildManifest = import 'util/build/buildManifest.jsonnet';
local buildManifests = import 'util/build/buildManifests.jsonnet';
local flinkCluster = import 'kafka/flink/flink-cluster.jsonnet';
local componentRegistry = import 'component-registry.jsonnet';

local buildComponent = function(component) [
  std.get(componentRegistry, component)(context, path="%s/%s" %[component, key], key=key)
  for key in std.objectFields(std.get(context.config, component))
];

local output =
clusterMain(context)
+ monitorMain(context);

local components =
  std.foldl(
    function(a,b) a + buildComponent(b),
    [
      "data",
      "sut",
      "infra",
      "load"
    ],
    []
  );

std.foldl(
  function(a,b) a+b,
  components,
  output
)