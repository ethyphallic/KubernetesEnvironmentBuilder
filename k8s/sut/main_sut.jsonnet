local global = import '../global.jsonnet';
local config = import '../../config.json';

local flinkSession = import 'flink-session.jsonnet';
local flinkDeployment = import 'flink.jsonnet';
local flinkJob = import 'heuristics-miner-flink-job.jsonnet';

local prefix = config.context.prefix;
local defaultNamespace = config.sut.namespace;
// Determine correct namespace
local namespace =
    if prefix != null && prefix != "" && defaultNamespace != null && defaultNamespace != "" then
        prefix + "-" + defaultNamespace
    else if defaultNamespace != null && defaultNamespace != "" then
        defaultNamespace
    else if prefix != null && prefix != "" then
        prefix   
    else
        "default";

// Session
local jobManagerConfig = config.sut.session.jobManager;
local taskManagerConfig = config.sut.session.taskManager;
local session = flinkSession.flinkSessionCluster(
    namespace=namespace, 
    jobManagerCPU=jobManagerConfig.cpu,
    jobManagerMemory=jobManagerConfig.memory, 
    taskManagerCPU=taskManagerConfig.cpu, 
    taskManagerMemory=taskManagerConfig.memory, 
    taskManagerReplicas=taskManagerConfig.replicas
);

// Jobs
local jobConfig = config.sut.jobs.heuristicsMinerFlink;
local job = flinkJob.heuristicsMinerFlinkJob(
    namespace = namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = jobConfig.group,
    parallelism = jobConfig.parallelism,
    bucketSize = jobConfig.bucketSize,
    andThreshold = jobConfig.andThreshold,
    dependencyThreshold = jobConfig.dependencyThreshold,
    variant = jobConfig.variant
);

// Deployments
local deploymentConfig = config.sut.deployments.heuristicsMinerFlink;
local deployment = flinkDeployment.heuristicsMinerFlinkDeployment(
    namespace = namespace,
    bootstrapServer = global.bootstrapServer,
    inputTopic = config.load.inputTopic,
    modelTopic = config.sut.topics.model,
    group = deploymentConfig.group,
    parallelism = deploymentConfig.parallelism,
    sampleSize = deploymentConfig.sampleSize,
    batchSize = deploymentConfig.batchSize,
    andThreshold = deploymentConfig.andThreshold,
    dependencyThreshold = deploymentConfig.dependencyThreshold
);

{
    "build/sut/flink-session/flink-session-jobmanager-deployment.json": session.jobManagerDeployment,
    "build/sut/flink-session/flink-session-jobmanager-service.json": session.jobManagerService,
    "build/sut/flink-session/flink-session-taskmanager-deployment.json": session.taskManagerDeployment,
    "build/sut/heuristics-miner-flink-job.json": job,
    "build/sut/flink-deployment.json": deployment
}