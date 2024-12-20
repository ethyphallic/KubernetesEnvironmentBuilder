local podChoas = import 'infra/pod-chaos.jsonnet';

local podFailure = podChoas.podFailure(
    duration='5s',
    namespace=kafkaNamespace,
    labelSelector={"strimzi.io/name": "power-kafka"}
);

{
    "build/chaos/pod-failure.json": podFailure
}