local load = import 'load.jsonnet';
local loadConfig = import 'load-cm.jsonnet';
local loadConfigDataSource = import 'datasource/assembly-line.jsonnet';
local kafkaTopic = import '../kafka/kafka-topic.jsonnet';
local imageProducer = import 'image-producer.jsonnet';
local build = import '../util/build-util.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';
local loadRegistry = import 'load-registry.jsonnet';

function(global, config) (
    local inputTopicName = config.load.inputTopic;
    local namespace = global.sutNamespace;

    local defDeployment = load.loadDefDeployment(namespace=namespace);
    local defBackendDeployment = load.loadBackendDeployment(namespace=namespace, topic=inputTopicName);
    local defBackendService = load.loadBackendService(namespace=namespace);
    local loadConfigmap = loadConfig.simulation(intensity=config.load.intensity, genTimeframesTilStart=100);
    local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %["load-backend", namespace], timeframe=1000);
    #local image_producer = imageProducer.buildFromConfig(config.load.data, );
    std.get(loadRegistry, "imageProducer")(config.load.data, {bootstrapServer: global.bootstrapServer, topic: "dog-input"})

    #buildManifest("load", "def-deployment", defDeployment)
    #+ buildManifest("load", "def-backend-deployment", defBackendDeployment)
    #+ buildManifest("load", "def-backend-service.json", defBackendService)
    #+ buildManifest("load", "load/load-config.json", loadConfigmap)
    #+ buildManifest("load", "sink/sink-config.json", sinkConfigmap)
    #+ { ["build/load/datasource/%s.json" %[std.stripChars(datasource.name, "<>")]] : datasource for datasource in loadConfigDataSource.all()}
)