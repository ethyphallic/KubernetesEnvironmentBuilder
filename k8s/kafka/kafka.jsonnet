local kafkaCluster = import 'resources/kafka-cluster.jsonnet';
local kafkaPodMonitor = import 'resources/kafka-podmonitor.jsonnet';
local kafkaExporterPodMonitor = import 'resources/kafka-exporter-podmonitor.jsonnet';

function(
  name="kafka",
  definition={
    brokerReplicas: 3,
    zookeeperReplicas: 3
  },
  externalParameter= {
    namespace: "kafka",
    host: "minikube"
  }
) [
  kafkaCluster(
    clusterName=name,
    brokerReplicas=definition.brokerReplicas,
    zookeeperReplicas=definition.zookeeperReplicas,
    namespace=externalParameter.namespace,
    host=externalParameter.host
  ),
  kafkaPodMonitor(name, externalParameter.namespace),
  kafkaExporterPodMonitor(name, externalParameter.namespace)
]