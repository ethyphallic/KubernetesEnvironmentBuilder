local podChoas = import 'pod-chaos.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local identifier = std.extVar('ID');
local infraNamespace = "scalablemine-" + identifier + "-infra";

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=infraNamespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

local networkDelay = networkChaos.networkDelay(10);

{
    "build/chaos/pod-failure.json": podFailure,
    "build/chaos/network-failure.json": networkDelay
}