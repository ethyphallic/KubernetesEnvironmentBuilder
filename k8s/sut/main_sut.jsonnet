local flink = import 'flink.jsonnet';
local global = import '../global.jsonnet';
local config = import '../../config.json';

local flinkDeployment = flink.heuristicsMinerFlinkDeployment(
    namespace = config.sut.namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = "heuristics-miner",
    parallelism = "1",
    sampleSize = "200",
    batchSize = "100",
    andThreshold = "0.5",
    dependencyThreshold = "0.5"
);

{
    "build/sut/flink-deployment.json": flinkDeployment
}