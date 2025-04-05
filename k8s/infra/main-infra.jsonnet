local networkChaos = import 'network-chaos.jsonnet';
local infraRegistry = import 'infra-registry.jsonnet';

function(context, path="infra", key="infra") (
    local infraConfig = std.get(context.config, key);
    std.get(infraRegistry(context), infraConfig.infraType)(path, infraConfig)
)
