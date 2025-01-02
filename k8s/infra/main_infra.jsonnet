local podChoas = import 'pod-chaos.jsonnet';

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace="infra",
    labelSelector={"strimzi.io/name": "power-kafka"}
);

{
    "build/chaos/pod-failure.json": podFailure
}