local buildManifests = import 'buildManifests.jsonnet';

function(path="", manifestName="", definition={}, externalParameter={}, buildFunction=function(){})
  buildManifests(
    path,
    manifestName,
    [
      local instance = std.get(definition, name);
      buildFunction(
        name,
        instance,
        externalParameter
      )
      for name in std.objectFields(definition)
    ]
  )