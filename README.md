# Ecoscape

Ecoscape is a simulated edge-cloud continuum testbed and a benchmark for fault remediation strategies.
Ecoscape leverages Kubernetes and the chaos engineering tool Chaos Mesh to simulate nodes within the edge-cloud
continuum. Additionally, it provides benchmarking scripts that simulates faults on the simulated edge and cloud nodes.
This enables the benchmark of remediation strategies. A remediation strategy is a set of actions to reconfigure a service
to sustain its Service Level Objectives (SLOs).

# Benchmark Definition

The Ecoscape Benchmark three configuration: The `SLOs`, the `duration` and the `directories`.

## SLO's

The SLO's are your requirements to your deployed service. They are defined via a quantifiable metric and a threshold.
The metrics are retrieved from Prometheus and are therefore formulated as Prometheus queries
For the Ecoscape Benchmark the files are stored in the `slo.yaml` file.

An examplary `slo.yaml` is the following:

```yaml
prometheus:
  url: <prometheus-url>
slos:
  - name: "processing-latency"
    query: "avg(latency{namespace=~'monitor'}!=0)"
    threshold: 1.5
    isBiggerBetter: false
    weight: 1
```

## Benchmark Duration

The Ecoscape Benchmark consists of different phases:
- Deployment Phase (System under Test is deployed)
- Warm-up Phase (Load Generator is deployed)
- Happy Phase (Evaluation of SLO starts)
- Chaos Phase (Faults are injected)

The duration of those phases are configured in the `duration.yaml`. 
Moreover, the number of repetitions are modified in that file.

```yaml
loadDelay: 20 #length of deployment phase in seconds
evalDelay: 20 #length of warm-up phase in seconds
chaosDelay: 20 #length of happy phase in seconds
duration: 60 #length of chaos phase in seconds
repetitions: 1
```

## Use-cases

Ecoscape gives the opportunity to support different system configurations. 
These are seTo change between different use cases parated in directories during the build process. 

## Getting Started
To run the Ecoscape Benchmark it is required to have access to a Kubernetes cluster. It is assumed that you have the  
KUBECONFIG environment variable set to the path of your kubeconfig. Additionally, Docker has to be installed on your machine.

To configure the systems you have to adopt the `config/config.jsonnet` file.
It consists out of 5 main sections `infra`, `data`, `sut`, `load` and `monitor`.

The `infra` describes the network topology and resource constraints within the computing setup.
The `data` definition describes the middleware that stores the data.
The `sut` defines the tested system while the `load` defines which data is produced to be handled.

To interact with the cluster you have the following commands to be used. You can either install the tools locally 
or you can use the docker container by running `ecoscape-tools.sh`.

## Run Ecoscape
After running the `ecoscape-tools.sh` you are in a docker container and you can run the commands referenced in the 
`Useful Commands` section. 
Before running the ecoscape benchmark a `build` has to be executed. By typing `ecoscape` you run the benchmark.
You can explore the configuration options by running `ecoscape --help`.
The results of the benchmarks are the stored in the `result` directory.

## Useful commands:
`build`: Builds the Kubernetes Mainfest files

`deploy {infra|sut|data|load}/{subcomponent}`: This deploys the part of the manifests that are specified. 
For example `deploy infra/networkChaos` deploys the infraStructure for the networkChaos use-case.

`delete {infra|sut|data|load}/{subcomponent}`: This deletes the manifests from the Kubernetes cluster

`kn {infra|sut|data|load|monitor}`: Switch between the namespaces.

`kafka <kafkaName>` Gives the URL of the bootstrap server
