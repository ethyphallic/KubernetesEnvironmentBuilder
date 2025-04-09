# Installation Guide
This project provides a local and an interactive docker container experience.
## Local
Please install the following programs:
- [helm](https://helm.sh/docs/intro/install/) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Additionally, for setting up a local Kubernetes cluster, we recommend using [minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/).

## Interactive Docker Container
All necessary tools are pre-installed in the Docker container

Execute the following script to build the image and start the interactive Docker container:
```bash
./docker.sh
```
If a container already exists, the script will either start or attach to it.
For further information about the script use `./docker.sh --help`.

This will mount the project as well as the `~/.kube/config` file into the docker container and therefore the installation of [kubectl](https://kubernetes.io/docs/tasks/tools/) is recommended to have a valid `~/.kube/config` file.

Edits outside of the docker container are reflected through the mount and vice versa. Additionally, the docker container has access to any cluster, that your system has access to.

# Build steps
## Minikube
1. **Start minikube**
```bash
minikube start --memory 8192 --cpus 2
```

2. **DNS**  
Then create a DNS entry for minikube.
```shell
sudo -- sh -c -e "echo '$(minikube ip) minikube' >> /etc/hosts"
```

## General
The following steps build the necessary files for the cluster and apply them.

0. **Config**  
Please ensure all values in the `config.json` file are up to date and match your needs, as these will be used in the following steps

1. **Kubernetes Operators**  
Install the necessary Kubernetes operators using Helm:
```bash
helm/build-helm.sh
```

2. **Resource Files**  
Generate the Kubernetes resource files:
```bash
./build-k8s.sh
```

3. **Build kafka resources.**  
```bash
kubectl apply -f build/kafka
```
Please wait after executing the command until all components are Ready. 
You can monitor them by running:
```bash
kubectl get pods -n kafka -w
```

# Helpful tools
To interact efficiently you can source the `interact.sh` script in your shell.
```bash
source interact.sh
```
This grants you access to additional interaction commands.  
In case you are using the interactive docker container, this step is automatically executed for you.

Provided Commands are :
#### Kubernetes
- `kn` - Allows for a quick contexts switch between namespaces.
- `build` - Shortcut for `./build-k8s.sh`
- `get_clusters` - List all the contexts in your kubeconfig file
- `sc` - Set the current-context in a kubeconfig file

#### Monitoring
- `prometheus` - Displays prometheus' url
- `grafana` - Displays grafanas url as well as the login data
#### Load Generator
- `start_load` - Starts the load generator depicted in `build/load`
- `stop_load` - Stops the load generator
#### Chaos Mesh
- `start_chaos` - Start the chaos mesh depicted in `build/chaos`
- `stop_chaos` - Stops the chaos mesh
- `delete_chaos` - Removes the chaos mesh from the cluster
#### Kafka
- `kafka_deploy` - Applies all kafka files in `build/kafka`
- `kafka_destroy` - Removes all kafka applications depicted in `build/kafka`
- `kafka_operator_restart` - Restarts the strimzi cluster operator
- `kafka` - Displays the kafka bootstrap server url
- `kafka_ui` - Displays kafka_ui's url