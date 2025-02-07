local config = import 'infra.json';
local nodeBuilder = import 'node.jsonnet';
local networkBuilder = import 'network.jsonnet';
local stressors = import 'stressors.jsonnet';
local global = import '../global.jsonnet';
local nodes = config.nodes;
local topic = "dog3";
local podMonitor = import 'podmonitor.jsonnet';

local new_config = import 'infra_new.json';
local data_node_config = new_config.data;

local data_node_names = std.objectFields(data_node_config);
local data_nodes = [
    local data_node_def = std.get(data_node_config, data_node_name);
    nodeBuilder.buildDataNode(
        appName=data_node_name,
        appLabel=data_node_def.location,
        bootstrapServer=global.bootstrapServer,
        topic=topic,
        sendInterval=data_node_def.sendRate
    ) for data_node_name in data_node_names
];

local network_topology = new_config.topology;
local network_nodes = std.objectFields(network_topology);
local network_links = [
    local network_node_def = std.get(network_topology, node).network;
    networkBuilder.buildLatency(
        appFrom=node,
        appTo=target_node,
        delayMs=std.get(network_node_def, target_node).latency
    )
    for node in network_nodes
    for target_node in std.objectFields(std.get(network_topology, node).network)
];

local worker_node_definition = new_config.system;
local worker_nodes = [
    local worker_node_def = std.get(worker_node_definition, worker_node);
    nodeBuilder.build(
        appName=worker_node,
        locationLabel=worker_node_def.location,
        memory=worker_node_def.ram,
        cpu=worker_node_def.cpu,
        bootstrapServer=global.bootstrapServer,
        topic=topic,
        modelDepth=worker_node_def.modelDepth,
        replicas=worker_node_def.replicas
    ) for worker_node in std.objectFields(worker_node_definition)
];

local pod_monitors = [
    podMonitor.createPodMonitor(name="%s-pod-monitor" %[worker_node], matchLabel={app: worker_node})
    for worker_node in std.objectFields(worker_node_definition)
];

local data_node_manifests = { ["build/load/data-%s.json" %[i]] : data_nodes[i] for i in std.range(0, std.length(data_nodes) - 1) };
local network_manifests   = { ["build/infra/network-%s.json" %[i]] : network_links[i] for i in std.range(0, std.length(network_links) - 1) };
local worker_manifests   = { ["build/sut/worker-%s.json" %[i]] : worker_nodes[i] for i in std.range(0, std.length(worker_nodes) - 1) };
local worker_pod_monitor_manifests   = { ["build/monitor/podmonitor-%s.json" %[i]] : pod_monitors[i] for i in std.range(0, std.length(pod_monitors) - 1) };

data_node_manifests + network_manifests + worker_manifests + worker_pod_monitor_manifests