local build = import '../util/build-util.jsonnet';
local buildManifest = import '../../util/build/buildManifest.jsonnet';
local buildManifests = import '../../util/build/buildManifests.jsonnet';
local load = import '../load.jsonnet';
local loadConfig = import '../load-cm.jsonnet';
local loadConfigDataSource = import '../datasource/assembly-line.jsonnet';

function (definition, global)(
    local namespace = global.loadNamespace;
    local bootstrapServer = global.bootstrapServer;
    local defDeployment = load.loadDefDeployment(namespace=namespace, bootstrapServer=bootstrapServer);
    local defBackendDeployment = load.loadBackendDeployment(namespace=namespace, topic=definition.inputTopic, bootstrapServer=bootstrapServer);
    local defBackendService = load.loadBackendService(namespace=namespace);
    local loadConfigmap = loadConfig.simulation(intensity=definition.intensity, genTimeframesTilStart=100);
    local sinkConfigmap = loadConfig.sink(serviceDomainName="%s.%s.svc" %["load-backend", namespace], timeframe=1000);

    buildManifest("load", "def-deployment", defDeployment)
    + buildManifest("load", "def-backend-deployment", defBackendDeployment)
    + buildManifest("load", "def-backend-service", defBackendService)
    + buildManifest("load", "load/load-config", loadConfigmap)
    + buildManifest("load", "sink/sink-config", sinkConfigmap)
    + { ["build/load/datasource/%s.json" %[std.stripChars(datasource.name, "<>")]] : datasource for datasource in loadConfigDataSource.all()}
)