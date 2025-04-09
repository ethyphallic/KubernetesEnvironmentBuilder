local podMonitor = import 'podmonitor.jsonnet';
local processMonitor = import 'process-monitor.jsonnet';
local prometheusValues = import 'prometheus-values.jsonnet';
local buildManifests = import '../util/build/build-manifests-from-map.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(context) (
    buildManifest(
        path="monitor/podmonitor",
        manifestName="podmonitor-process-monitor",
        manifest=podMonitor(
           name="process-monitor",
           definition={matchLabel: "process-monitor"},
           externalParameter={namespace: context.functions.monitorNamespace}
        )
    )
    + buildManifests(
        path="monitor",
        manifestName="process-monitor",
        definition=context.config.monitor,
        externalParameter={
            namespace: context.functions.monitorNamespace,
            bootstrapServer: context.functions.bootstrapServer,
        },
        buildFunction=processMonitor
    )
    + buildManifest(
        path="helm",
        manifestName="prometheus-values",
        manifest=prometheusValues(
          namespace=context.functions.monitorNamespace
        )
    )
)
