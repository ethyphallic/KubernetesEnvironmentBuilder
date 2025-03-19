local namespaceCreator = import 'namespace.jsonnet';
local rbac = import 'rbac.jsonnet';
local config = import '../../config.json';

local namespaces = [config.infra.namespace, config.kafka.namespace, config.monitor.namespace, config.load.namespace, config.sut.namespace];

local ns = { ["build/cluster/namespace/namespace-%s.json" %[namespace]] : namespaceCreator.createNamespace(namespace) for namespace in namespaces };
local role = { ["build/cluster/role-%s.json" %[namespace]] : rbac.getRole(namespace) for namespace in namespaces };
local rb = { ["build/cluster/rolebinding-%s.json" %[namespace]] : rbac.getRoleBinding(namespace, "stu208763") for namespace in namespaces };

ns + role + rb