local config = import 'infra.json';
local nodeBuilder = import 'node.jsonnet';
local networkBuilder = import 'network.jsonnet';
local stressorBuilder = import 'stressors.jsonnet';
local global = import '../global.jsonnet';
local nodes = config.nodes;
local topic = "dog3";
local podMonitor = import 'podmonitor.jsonnet';
local new_config = import 'scenario/02_stress.json';
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

local topology = new_config.topology;
local nodes = std.objectFields(topology);

local network_links = [
    local network_node_def = std.get(topology, node).network;
    networkBuilder.buildLatency(
        appFrom=node,
        appTo=target_node,
        delayMs=std.get(network_node_def, target_node).latency
    )
    for node in nodes
    for target_node in std.objectFields(std.get(topology, node).network)
];

local cpu_stressor_definitions = [
    local target_node = std.get(topology, node);
    local node_def = std.get(topology, node);
    if std.objectHas(node_def, "stressor") then
    local stressor_def = node_def.stressor;
    if std.objectHas(stressor_def, "cpu") then
    stressorBuilder.buildCpuStressor(
        target=node,
        load=std.get(stressor_def, "cpu")
    )
    for node in nodes
];

local memory_stressor_definitions = [
    local target_node = std.get(topology, node);
    local node_def = std.get(topology, node);
    if std.objectHas(node_def, "stressor") then
    local stressor_def = node_def.stressor;
    if std.objectHas(stressor_def, "memory") then
    stressorBuilder.buildCpuStressor(
        target=node,
        load=std.get(stressor_def, "memory")
    )
    for node in nodes
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
local cpu_stressor_manifests   = { ["build/infra/cpu_stressor-%s.json" %[i]] : cpu_stressor_definitions[i] for i in std.range(0, std.length(cpu_stressor_definitions) - 1) };
local memory_stressor_manifests   = { ["build/infra/memory_stressor-%s.json" %[i]] : memory_stressor_definitions[i] for i in std.range(0, std.length(memory_stressor_definitions) - 1) };
local worker_manifests   = { ["build/sut/worker-%s.json" %[i]] : worker_nodes[i] for i in std.range(0, std.length(worker_nodes) - 1) };
local worker_pod_monitor_manifests   = { ["build/monitor/podmonitor-%s.json" %[i]] : pod_monitors[i] for i in std.range(0, std.length(pod_monitors) - 1) };

data_node_manifests + network_manifests + cpu_stressor_manifests + memory_stressor_manifests + worker_manifests + worker_pod_monitor_manifests