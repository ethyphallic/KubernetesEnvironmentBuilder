local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local config = import '../../config.json';

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=config.infra.namespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

build.buildManifests("infra", "network", networkBuilder.buildFromConfig(topology))