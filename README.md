# Ecoscape

Ecoscape is a tool for testing distributed environments within Kubernetes. It is originally designed to test Kubernetes 
remediation strategies.

## Getting Started
To run the Ecoscape Benchmark it is required to have access to a Kubernetes cluster. It is assumed that you have the  
KUBECONFIG environment variable set to the path of your kubeconfig. Additionally, Docker has to be installed on your machine.
If you would like to work with different Kubernetes Namespaces

---

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
