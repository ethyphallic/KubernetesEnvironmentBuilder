{
 getHpa(deploymentName):: {
   apiVersion: "autoscaling/v2",
   kind: "HorizontalPodAutoscaler",
   metadata: {
     name: "hpa-demo-deployment",
     namespace: "scalablemine-hkr-sut"
   },
   spec: {
     scaleTargetRef: {
       apiVersion: "apps/v1",
       kind: "Deployment",
       name: deploymentName
     },
     minReplicas: 0,
     maxReplicas: 5,
     metrics: [
       {
         type: "Resource",
         resource: {
           name: "cpu",
           target: {
             type: "Utilization",
             averageUtilization: 50
           }
         }
       }
     ]
   }
 },
  getAstrolabe():: {
    apiVersion: "astrolabe.github.com/v1",
    kind: "Astrolabe",
    metadata: {
      labels: {
        "app.kubernetes.io/name": "astrolabe",
      },
      name: "astrolabe-sample"
    },
    spec: {
      jobs: [
        {
          selector: {
            matchLabels: {
              app: "system32"
            }
          },
          template: {
            metadata: {
              name: "system32",
              labels: {
                app: "system32"
              }
            },
            spec: {
              containers: [
                {
                  name: "cpu-stressor",
                  image: "narmidm/k8s-pod-cpu-stressor",
                  args: [
                    "-cpu=0.5",
                    "-forever"
                  ]
                }
              ]
            }
          }
        },
        {
          selector: {
            matchLabels: {
              app: "nginx32"
            }
          },
          template: {
            metadata: {
              name: "nginx32",
              labels: {
                app: "nginx32"
              }
            },
            spec: {
              containers: [
                {
                  name: "nginx",
                  image: "nginx:1.14.2"
                }
              ]
            }
          }
        }
      ],
      prometheus: {
        address: "http://10.244.1.127",
        port: 9090
      },
      actions: [
        {
          type: "replica",
          min: 5,
          max: 10
        }
      ],
      metrics: [
        {
          name: "msCPU",
          type: "prometheus",
          query: "sum(container_cpu_usage_seconds_total{namespace='default', pod=~'system32.*'})"
        }
      ],
      slos: [
        {
          metric: "msCPU",
          evaluation: "geq",
          threshold: 500
        }
      ]
    }
  }
}