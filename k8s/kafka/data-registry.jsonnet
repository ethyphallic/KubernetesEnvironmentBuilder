local buildManifests = import '../util/build/buildManifests.jsonnet';
local flinkCluster = import 'flink/flink-cluster.jsonnet';
local kafkaCluster = import 'kafka-cluster.jsonnet';

function(context){
  kafka(path="kafka", definition): kafkaCluster(
    context,
    path=path
  ),
  flink(path="kafka", definition):
    buildManifests(
      path,
      "flink",
      flinkCluster(
        "flink",
        context.config.data.flink,
        externalParameters={namespace: context.functions.kafkaNamespace}
      )
    )
}