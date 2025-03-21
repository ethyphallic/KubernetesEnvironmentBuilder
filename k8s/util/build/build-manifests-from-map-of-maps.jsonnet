local buildManifests = import 'buildManifests.jsonnet';

function(
  path="infra",
  manifestName="nmae",
  definition={},
  externalParameters={},
  buildFunction=function(){}
)
buildManifests(
  path=path,
  manifestName=manifestName,
  manifests=[
      local subdefinition=std.get(std.get(definition, name1), name2);
      buildFunction(
          name1=name1,
          name2=name2,
          definition=subdefinition,
          externalParameters=externalParameters
      )
      for name1 in std.objectFields(definition)
      for name2 in std.objectFields(std.get(definition, name1))
  ]
)