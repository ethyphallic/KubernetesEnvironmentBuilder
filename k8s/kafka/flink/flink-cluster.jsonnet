local taskManager = import "flink-taskmanager.jsonnet";
local jobManager = import "flink-jobmanager.jsonnet";
local jobManagerService = import "flink-jobmanager-service.jsonnet";

function(name, definition, externalParameters)
  [
    taskManager(name, definition.taskManager, externalParameters),
    jobManager(name, definition.jobManager, externalParameters),
    jobManagerService(externalParameters)
  ]