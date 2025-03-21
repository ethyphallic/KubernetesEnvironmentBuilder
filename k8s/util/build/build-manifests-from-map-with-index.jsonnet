local buildManifests = import 'buildManifests.jsonnet';

function(
  path="",
  manifestName="name",
  definition={},
  externalParameters={},
  buildFunction=function(){}
)
buildManifests(
  path=path,
  manifestName=manifestName,
  manifests=[
    local fields = std.objectFields(definition);
    local instance = std.get(definition, fields[i]);
    buildFunction(
      name=fields[i],
      index=i,
      definition=instance,
      externalParameters=externalParameters
    )
    for i in std.range(0, std.length(std.objectFields(definition)) - 1)
  ]
)


