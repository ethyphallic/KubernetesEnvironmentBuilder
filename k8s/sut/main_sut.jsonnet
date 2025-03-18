local flink = import 'flink.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';

local flinkDeployment = flink.heuristicsMinerFlinkDeployment(
    namespace = config.sut.namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = config.sut.deployments.flinkHeuristicMiner.group,
    parallelism = config.sut.deployments.flinkHeuristicMiner.parallelism,
    sampleSize = config.sut.deployments.flinkHeuristicMiner.sampleSize,
    batchSize = config.sut.deployments.flinkHeuristicMiner.batchSize,
    andThreshold = config.sut.deployments.flinkHeuristicMiner.andThreshold,
    dependencyThreshold = config.sut.deployments.flinkHeuristicMiner.dependencyThreshold
);

{
    "build/sut/flink-deployment.json": flinkDeployment
}