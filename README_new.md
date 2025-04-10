# Ecoscape

Ecoscape is a tool for testing distributed environments within Kubernetes.

## Getting Started

To configure the systems you have to adopt the `config.jsonnet` file.
It consists out of 4 main sections `infra`, `data`, `sut` and `load`

The `infra` describes the network topology and resource constraints within the computing setup.
The `data` definition describes the middleware that stores the data.
The `sut` defines the tested system while the `load` defines which data is produced to be handled.

To interact with the cluster you have the following commands to be used. You can either install the tools locally 
or you can use the docker container by running 
`docker run -it --rm --network=host -v $KUBECONFIG:/root/.kube/config -v .:/app hendrikreiter/ecoscape:0.1.0`

Useful commands:

`build`: Builds the Kubernetes Mainfest files

`deploy {infra|sut|data|load}/{subcomponent}`: This deploys the part of the manifests that are specified. 
For example `deploy infra/networkChaos` deploys the infraStructure for the networkChaos use-case.

`delete {infra|sut|data|load}/{subcomponent}`: This deletes the manifests from the Kubernetes cluster

`kn {infra|sut|data|load}`: Switch between the namespaces.
