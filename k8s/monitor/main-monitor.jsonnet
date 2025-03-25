local podMonitor = import 'podmonitor.jsonnet';
local processMonitor = import 'process-monitor.jsonnet';
local buildManifests = import '../util/build/build-manifests-from-map.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(context) (
    buildManifest(
        path="monitor",
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
)
