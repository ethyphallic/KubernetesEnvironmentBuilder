local sutRegistry = import 'sut-registry.jsonnet';

function(context) (
    std.get(sutRegistry(context), context.config.sut.sutType)(context.config.sut.system)
)