local podChoas = import 'pod-chaos.jsonnet';
local buildManifestsFromMapOfMaps = import '../util/build/build-manifests-from-map-of-maps.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';

function(global, config, path="infra")(
  buildManifestsFromMapOfMaps(
    path=path,
    manifestName="network",
    definition=config.infra.topology.network,
    buildFunction=networkChaos,
    externalParameters={
      namespace: global.global.infraNamespace,
      affectedNamespaces: [
        global.global.kafkaNamespace,
        global.global.loadNamespace,
        global.global.sutNamespace,
      ]
    }
  )
)
