local dpmBenchDashboard = import 'dashboard/dpm-bench-dashboard.json';
local keplerDashboard = import 'dashboard/kepler-dashboard.json';
local podMonitor = import 'podmonitor.jsonnet';
local processMonitor = import 'process-monitor.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';
local global = import '../global.jsonnet';

local name = "reporter-podmonitor";
local monitor = podMonitor.createPodMonitor(name=name, matchLabel={app: "process-monitor"});

buildManifest(path="monitor", manifestName=name, manifest=monitor)
+ buildManifest(
  path="monitor",
  manifestName="process-monitor",
  manifest=processMonitor(global.monitorNamespace, global.bootstrapServer)
) +
{
    "build/monitor/dpm-bench-dashboard.json": dpmBenchDashboard,
    "build/monitor/kepler-dashboard.json": keplerDashboard
}