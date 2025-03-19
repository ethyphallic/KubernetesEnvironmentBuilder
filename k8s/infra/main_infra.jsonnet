local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local config = import '../../config.json';

local prefix = config.context.prefix;
local defaultNamespace = config.infra.namespace;
local namespace = if prefix != null && prefix != "" then prefix + "-" + defaultNamespace else defaultNamespace;

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=namespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

local networkDelay = networkChaos.networkDelay(10 , [ namespace ] );

{
    "build/chaos/pod-failure.json": podFailure,
    "build/chaos/network-failure.json": networkDelay
}