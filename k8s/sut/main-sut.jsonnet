local sutRegistry = import 'sut-registry.jsonnet';

function(global, config) (
    std.get(sutRegistry(global), config.sutType)(config.system)
)