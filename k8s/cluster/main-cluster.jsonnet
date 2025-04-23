local namespaceCreator = import 'namespace.jsonnet';
local rbac = import 'rbac.jsonnet';
local clusterConfig = import 'cluster-config.jsonnet';
local serviceAccount = import 'service-account.jsonnet';
local serviceAccountSecret = import 'service-account-secret.jsonnet';
local buildManifest = import '../util/build/buildManifest.jsonnet';

function(context) (
    local namespaces = ["%s%s" %[context.config.context.prefix, name] for name in ["default", "kafka", "load", "sut", "infra", "monitor"]];

    local saName = "sa-%s" %[context.config.context.prefix];
    local saNamespace = context.config.context.prefix + "default";
    local ns = { ["build/cluster/namespace/namespace-%s.json" %[namespace]] : namespaceCreator.createNamespace(namespace) for namespace in namespaces };
    local role = { ["build/cluster/role-%s.json" %[namespace]] : rbac.getRole(namespace) for namespace in namespaces };
    local rb = { ["build/cluster/rolebinding-%s.json" %[namespace]] : rbac.getRoleBinding(namespace, saName, saNamespace) for namespace in namespaces };
    local configManifest = buildManifest(
      "",
      "cluster-config",
      clusterConfig(
        prefix=context.config.context.prefix,
        kafkaNamespace=context.functions.kafkaNamespace,
        loadNamespace=context.functions.loadNamespace,
        infraNamespace=context.functions.infraNamespace,
        sutNamespace=context.functions.sutNamespace,
        monitorNamespace=context.functions.monitorNamespace
      )
    );
    local sa = buildManifest(
      "cluster",
      "sa",
      serviceAccount(saName, saNamespace)
    );
    local saSecret = buildManifest(
      "cluster",
      "sa-secret",
      serviceAccountSecret(saName, saNamespace)
    );

    ns + role + rb + configManifest + sa + saSecret
)