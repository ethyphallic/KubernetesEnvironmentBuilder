local global = import '../../global.jsonnet';

{
   loadDefDeployment():: {
     apiVersion: "apps/v1",
     kind: "Deployment",
     metadata: {
       name: "distributed-event-factory",
       namespace: "load",
       labels: {
         app: "distributed-event-factory"
       }
     },
     spec: {
       replicas: 1,
       selector: {
         matchLabels: {
           app: "distributed-event-factory"
         }
       },
       template: {
         metadata: {
           labels: {
             app: "distributed-event-factory"
           }
         },
         spec: {
           containers: [
             {
               name: "distributed-event-factory",
               image: "hendrikreiter/distributed_event_factory:0.2.2",
               imagePullPolicy: "IfNotPresent",
               env: [
                 {
                    name: "LOAD",
                    value: "1"
                 },
                 {
                    name: "SIMULATION",
                    value: "load-config.json"
                 },
                 {
                    name: "DATASOURCE",
                    value: "assemblyline"
                 },
                 {
                    name: "SINK",
                    value: "sink-config.json"
                 },
                 {
                    name: "ROOT",
                    value: "/app"
                 }
               ],
               ports: [
                 {
                   containerPort: 8080
                 }
               ],
               resources: {
                 requests: {
                   cpu: "300m",
                   memory: "200Mi"
                 },
               },
               volumeMounts: [
                 {
                    name: "def-datasource-config",
                    mountPath: "/app/config/datasource/assemblyline"
                 },
                 {
                    name: "def-load-config",
                    mountPath: "/app/config/simulation"
                 },
                 {
                    name: "def-sink-config",
                    mountPath: "/app/config/sink"
                 }
               ]
             }
           ],
           volumes: [
             {
               name: "def-datasource-config",
               configMap: {
                 name: "def-datasource"
               }
             },
             {
               name: "def-load-config",
               configMap: {
                 name: "def-load"
               }
             },
             {
               name: "def-sink-config",
               configMap: {
                 name: "def-sink"
               }
             }
           ]
         }
       }
     }
   },
   loadBackendDeployment(topic):: {
     apiVersion: "apps/v1",
     kind: "Deployment",
     metadata: {
       name: "load-backend",
       namespace: "load",
       labels: {
         app: "load-backend"
       }
     },
     spec: {
       replicas: 1,
       selector: {
         matchLabels: {
           app: "load-backend"
         }
       },
       template: {
         metadata: {
           labels: {
             app: "load-backend"
           }
         },
         spec: {
           containers: [
             {
               name: "load-backend",
               image: "hendrikreiter/def-loadtest-backend:0.1.0",
               imagePullPolicy: "IfNotPresent",
               env: [
                 {
                    name: "TOPIC",
                    value: topic
                 },
                 {
                    name: "BOOTSTRAP_SERVER",
                    value: global.bootstrapServer
                 }
               ],
               resources: {
                 requests: {
                   cpu: "750m",
                   memory: "250Mi"
                 },
               },
               ports: [
                 {
                   containerPort: 8080
                 }
               ]
             }
           ]
         }
       }
     }
   },
   loadBackendService():: {
     apiVersion: "v1",
     kind: "Service",
     metadata: {
        name: "load-backend",
        namespace: "load"
     },
     spec: {
        selector: {
            app: "load-backend"
        },
        ports: [
          {
            port: 8080,
            targetPort: 8080
          }
        ]
     }
   }
}