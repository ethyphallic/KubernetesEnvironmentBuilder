local config = import 'config.json';
local identifier = std.extVar('ID');
local kafkaNamespace = "scalablemine-" + identifier + "-kafka";

{
    bootstrapServer: config.kafka.clusterName + "-kafka-bootstrap." + kafkaNamespace + ".svc:9092"
}