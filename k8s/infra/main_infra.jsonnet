local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local config = import '../../config.json';

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=config.infra.namespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

local networkDelay = networkChaos.networkDelay(10);

{
    "build/chaos/pod-failure.json": podFailure,
    "build/chaos/network-failure.json": networkDelay
}