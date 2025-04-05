local buildManifestsFromMapOfMaps = import '../util/build/build-manifests-from-map-of-maps.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local networkChaos = import 'network-chaos.jsonnet';
local cpuStress = import 'cpu-stressor.jsonnet';

function(context)
{
  networkTopology(path, definition): buildManifestsFromMapOfMaps(
    path=path,
    manifestName="infra",
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
  ),
  networkChaos(definition): {},
  cpuStress(path, definition): buildManifest(
    path=path,
    manifestName="cpu-stress",
    manifest=cpuStress(
      definition=definition,
      externalParameter={
        namespace: context.functions.infraNamespace,
        affectedNamespaces: [
          context.functions.sutNamespace
        ]
      }
    )
  )
}