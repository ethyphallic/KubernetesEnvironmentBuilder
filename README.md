# Installation Guide

First install the following programs: 
- [minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/)
- [helm](https://helm.sh/docs/intro/install/) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)


# Build steps 

1. Start minikube
```bash
minikube start --memory 8192 --cpus 2
```

Then create a dns name for minikube.
```shell
sudo -- sh -c -e "echo '$(minikube ip) minikube' >> /etc/hosts"
```

2. Install the Kubernetes operators using helm
```bash
helm/build-helm.sh
```

3. Build Kubernetes resource files
```bash
./build-k8s.sh
```

4. Build kafka resources. 
```bash
kubectl apply -f build/kafka
```
Please wait after executing the command until all components are Ready. 
You can monitor them by running:
```bash
kubectl get pods -n kafka -w
```

To interact with the cluster you can source the `interact.sh` script in your shell. 
Then you have access to additional interaction commands.
```bash
source interact.sh
```

In that shell you can now use some fancy commands:

`kafka_ui`: Gives you the url to the Kafka-UI

`grafana`: Gives you the url to your Grafana Dashboards

`start_load`: Starts the load generator

`stop_load`: Stops the load generator