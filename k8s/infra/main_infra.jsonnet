local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local buildManifests = import '../util/build/buildManifests.jsonnet';
local networkBuilder = import 'network-builder.jsonnet';

function(global, config, path="infra")(
    buildManifests(path, "network", networkBuilder.buildFromConfig(config.infra.topology))
)
