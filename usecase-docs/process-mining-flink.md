# Process Mining Flink

The object recognition use case includes a deployment of kafka cluster, 
worker pods that classify the images and a load generator that produces the images.

To run the scenario go to the `k8s/context.jsonnet` and specify reference the following file in the config.json:
`local config = import '../config/examples/object-recognition.jsonnet';`

Before you build your scenario add the `prefix` of your namespace in the file `config/context/cluster.json`

Then build the Kubernetes manifests with the `build` command.

Run the following commands step by step to get the full setup:

`deploy data/kafka`
`deploy data/kafka/topic`
`deploy data/kafka/ui`
`deploy data/flink`
`deploy infra/infra`
`deploy sut/original`
`start_load`
