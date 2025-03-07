local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local networkBuilder = import 'network-builder.jsonnet';
local build = import '../util/build-util.jsonnet';
local config = import '../../config.json';
local topology = config.infra.topology;

build.buildManifests("infra", "network", networkBuilder.buildFromConfig(topology))
