local sutRegistry = import 'sut-registry.jsonnet';

function(context, path="sut") (
    std.get(sutRegistry(context), context.config.sut.sutType)(context.config.sut.system)
)