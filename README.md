# Installation Guide for Kafka on Kubernetes

First install the following programs: 
- [minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/)
- [helm](https://helm.sh/docs/intro/install/) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [jsonnet](https://github.com/google/jsonnet)

Enable the metrics-server in minikube
```shell
minikube addons enable metrics-server
```

Start minikube with additional memory
```shell
minikube start --memory 8192
```

Create a dns name for minikube.
```shell
sudo -- sh -c -e "echo '$(minikube ip) minikube' >> /etc/hosts"
```

Setup Strimzi (Kafka on Kubernetes)
```shell
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
```

Build the kubernetes files
```shell
./build-k8s.sh
```

Apply the Kafka files and wait until all components get into the Ready state
```shell
kubectl apply -f build/kafka
```
