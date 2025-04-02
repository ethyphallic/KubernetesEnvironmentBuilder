local namespaceCreator = import 'namespace.jsonnet';
local rbac = import 'rbac.jsonnet';
local clusterConfig = import 'cluster-config.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(context) (
    local namespaces = ["%s%s" %[context.config.context.prefix, name] for name in ["default", "kafka", "load", "sut", "infra"]];

    local ns = { ["build/cluster/namespace/namespace-%s.json" %[namespace]] : namespaceCreator.createNamespace(namespace) for namespace in namespaces };
    local role = { ["build/cluster/role-%s.json" %[namespace]] : rbac.getRole(namespace) for namespace in namespaces };
    local rb = { ["build/cluster/rolebinding-%s.json" %[namespace]] : rbac.getRoleBinding(namespace, "stu208763") for namespace in namespaces };
    local configManifest = buildManifest(
      "cluster",
      "cluster-config",
      clusterConfig(
        context.config.context.prefix,
        kafkaNamespace=context.functions.kafkaNamespace,
        loadNamespace=context.functions.loadNamespace,
        infraNamespace=context.functions.infraNamespace,
        sutNamespace=context.functions.sutNamespace,
        monitorNamespace=context.functions.monitorNamespace
      )
    );
    ns + role + rb + configManifest
)