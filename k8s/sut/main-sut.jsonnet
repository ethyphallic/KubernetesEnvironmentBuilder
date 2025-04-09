local sutRegistry = import 'sut-registry.jsonnet';

function(context, path="sut", key="system") (
    local sutConfig = std.get(context.config.sut, key);
    std.get(sutRegistry(context), std.get(sutConfig, "sutType"))(path, std.get(sutConfig, "system"))
)