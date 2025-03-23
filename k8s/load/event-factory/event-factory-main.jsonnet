local build = import '../util/build-util.jsonnet';
local defDeployment = import 'def-deployment.jsonnet';
local simulation = import 'def-simulation.jsonnet';
local sink = import 'def-sink.jsonnet';
local backend = import 'def-backend.jsonnet';
local buildManifest = import '../../util/build/buildManifest.jsonnet';
local buildManifests = import '../../util/build/buildManifests.jsonnet';
local buildManifestsFromMap = import '../../util/build/build-manifests-from-map.jsonnet';
local load = import '../load.jsonnet';
local loadConfig = import '../load-cm.jsonnet';

function (
    definition={
        location: "",
        sendInterval: "1",
        memory: "128Mi",
        cpu: "500m",
    },
    externalParameters={
        namespace: "load",
        bootstrapServer: "",
        inputTopic: ""
    }
)
    local namespace = externalParameters.namespace;
    local bootstrapServer = externalParameters.bootstrapServer(definition.kafkaCluster);
    local def = defDeployment(namespace=namespace);
    local defBackend = backend(namespace=namespace, topic=definition.inputTopic, bootstrapServer=bootstrapServer);
    local defSimulation = simulation(intensity=definition.intensity, genTimeframesTilStart=100);
    local defSink = sink(serviceDomainName="%s.%s.svc" %["load-backend", namespace], timeframe=1000);

    buildManifest("load", "def", def)
    + buildManifests("load", "backend", defBackend)
    + buildManifest("load/load", "simulation", defSimulation)
    + buildManifest("load/sink", "sink", defSink)
    + buildManifestsFromMap(
      path="load/datasource",
      manifestName="datasource",
      definition=definition.datasource,
      externalParameter={},
      buildFunction=function(name,definition,externalParameters) definition
    )