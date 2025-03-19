local flink = import 'flink.jsonnet';
local heur = import 'heuristics-miner-flink-deployment.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';

local prefix = config.context.prefix;
local defaultNamespace = config.sut.namespace;
local namespace = if prefix != null && prefix != "" then prefix + "-" + defaultNamespace else defaultNamespace;

local flinkHeuristicMiner = config.sut.deployments.flinkHeuristicMiner;
local flinkDeployment = flink.heuristicsMinerFlinkDeployment(
    namespace = namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = flinkHeuristicMiner.group,
    parallelism = flinkHeuristicMiner.parallelism,
    sampleSize = flinkHeuristicMiner.sampleSize,
    batchSize = flinkHeuristicMiner.batchSize,
    andThreshold = flinkHeuristicMiner.andThreshold,
    dependencyThreshold = flinkHeuristicMiner.dependencyThreshold
);

local heuristicsMinerFlinkDeployment = config.sut.deployments.heuristicsMinerFlinkDeployment;
local flinkDeployment2 = heur.heuristicsMinerFlinkDeployment(
    namespace = namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = heuristicsMinerFlinkDeployment.group,
    parallelism = heuristicsMinerFlinkDeployment.parallelism,
    bucketSize = heuristicsMinerFlinkDeployment.bucketSize,
    andThreshold = heuristicsMinerFlinkDeployment.andThreshold,
    dependencyThreshold = heuristicsMinerFlinkDeployment.dependencyThreshold,
    variant = heuristicsMinerFlinkDeployment.variant,
    jobManagerMemory = heuristicsMinerFlinkDeployment.jobManager.memory,
    jobManagerCPU = heuristicsMinerFlinkDeployment.jobManager.cpu,
    taskManagerMemory = heuristicsMinerFlinkDeployment.taskManager.memory,
    taskManagerCPU = heuristicsMinerFlinkDeployment.taskManager.cpu,
    taskManagerTaskSlots = heuristicsMinerFlinkDeployment.taskManager.taskSlots
);

{
    "build/sut/flink-deployment.json": flinkDeployment,
    "build/sut/heuristics-miner-flink-deployment.json": flinkDeployment2
}