{
    iterateOver(definition={}, externalParameter={}, buildFunction=function(){})::
      [
        local instance = std.get(definition, name);
        buildFunction(
          name,
          instance,
          externalParameter)
        for name in std.objectFields(definition)
      ]
}