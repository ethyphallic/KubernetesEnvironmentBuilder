local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace="kafka",
    labelSelector={"strimzi.io/name": "power-kafka"}
);

local networkDelay = networkChaos.networkDelay(10);

{
    "build/chaos/pod-failure.json": podFailure,
    "build/chaos/network-failure.json": networkDelay
}