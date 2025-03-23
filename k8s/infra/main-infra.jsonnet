local podChoas = import 'pod-chaos.jsonnet';
local buildManifestsFromMapOfMaps = import '../util/build/build-manifests-from-map-of-maps.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';

function(context, path="infra")(
  buildManifestsFromMapOfMaps(
    path=path,
    manifestName="network",
    definition=context.config.infra.topology.network,
    buildFunction=networkChaos,
    externalParameters={
      namespace: context.functions.infraNamespace,
      affectedNamespaces: [
        context.functions.kafkaNamespace,
        context.functions.loadNamespace,
        context.functions.sutNamespace,
      ]
    }
  )
)
