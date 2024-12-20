local flinkDeployment = flink.heuristicsMinerFlinkDeployment(
    namespace = kafkaNamespace,
    bootstrapServer = bootstrapServer,
    inputTopic = inputTopicName,
    modelTopic = modelTopicName,
    group = "heuristics-miner",
    parallelism = "1",
    sampleSize = "200",
    batchSize = "100",
    andThreshold = "0.5",
    dependencyThreshold = "0.5"
);

local flink = import 'sut/flink.jsonnet';

{
    "build/flink/flink-deployment.json": flinkDeployment
}