function(namespace) [
{
  apiVersion: "v1",
  kind: "ServiceAccount",
  metadata: {
    name: "kafbat-ui-kafka-ui",
    namespace: namespace,
    labels: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui",
    }
  }
},
{
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: "kafbat-ui-kafka-ui-fromvalues",
    namespace: namespace,
    labels: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui",
    }
  },
  data: {
    "config.yml": std.toString({
      auth: {
        type: "disabled"
      },
      kafka: {
        clusters: [
          {
            bootstrapServers: "zone1-kafka-bootstrap:9092",
            name: "zone1"
          },
          {
            bootstrapServers: "zone2-kafka-bootstrap:9092",
            name: "zone2"
          }
        ]
      },
      management: {
        health: {
          ldap: {
            enabled: false
          }
        }
      }
    })
  }
},
{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: "kafbat-ui-kafka-ui",
    namespace: namespace,
    labels: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui"
    }
  },
  spec: {
    type: "NodePort",
    ports: [
      {
        port: 80,
        targetPort: "http",
        protocol: "TCP",
        name: "http"
      }
    ],
    selector: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui"
    }
  }
},
{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: "kafbat-ui-kafka-ui",
    namespace: namespace,
    labels: {
      "helm.sh/chart": "kafka-ui-1.4.12",
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui",
      "app.kubernetes.io/version": "v1.2.0",
      "app.kubernetes.io/managed-by": "Helm"
    }
  },
  spec: {
    type: "NodePort",
    ports: [
      {
        port: 80,
        targetPort: "http",
        protocol: "TCP",
        name: "http"
      }
    ],
    selector: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui"
    }
  }
}
{
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: "kafbat-ui-kafka-ui",
    namespace: namespace,
    labels: {
      "app.kubernetes.io/name": "kafka-ui",
      "app.kubernetes.io/instance": "kafbat-ui",
    }
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        "app.kubernetes.io/name": "kafka-ui",
        "app.kubernetes.io/instance": "kafbat-ui"
      }
    },
    template: {
      metadata: {
        labels: {
          "app.kubernetes.io/name": "kafka-ui",
          "app.kubernetes.io/instance": "kafbat-ui"
        }
      },
      spec: {
        serviceAccountName: "kafbat-ui-kafka-ui",
        securityContext: {},
        containers: [
          {
            name: "kafka-ui",
            securityContext: {},
            image: "ghcr.io/kafbat/kafka-ui:v1.2.0",
            imagePullPolicy: "IfNotPresent",
            env: [
              {
                name: "SPRING_CONFIG_ADDITIONAL-LOCATION",
                value: "/kafka-ui/config.yml"
              }
            ],
            ports: [
              {
                name: "http",
                containerPort: 8080,
                protocol: "TCP"
              }
            ],
            livenessProbe: {
              httpGet: {
                path: "/actuator/health",
                port: "http"
              },
              initialDelaySeconds: 60,
              periodSeconds: 30,
              timeoutSeconds: 10
            },
            readinessProbe: {
              httpGet: {
                path: "/actuator/health",
                port: "http"
              },
              initialDelaySeconds: 60,
              periodSeconds: 30,
              timeoutSeconds: 10
            },
            resources: {},
            volumeMounts: [
              {
                name: "kafka-ui-yaml-conf",
                mountPath: "/kafka-ui/"
              }
            ]
          }
        ],
        volumes: [
          {
            name: "kafka-ui-yaml-conf",
            configMap: {
              name: "kafbat-ui-kafka-ui-fromvalues"
            }
          }
        ]
      }
    }
  }
}
]
