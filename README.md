# Installation Guide for Kafka on Kubernetes

First install the following programs: 
- [minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/)
- [helm](https://helm.sh/docs/intro/install/) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [jsonnet](https://github.com/google/jsonnet)

Start minikube with additional memory
```shell
minikube start --memory 8192
```

Create a dns name for minikube.
```shell
sudo -- sh -c -e "echo '$(minikube ip) minikube' >> /etc/hosts"
```

Build the environment with all helm charts and 
```shell
./build-env.sh
```

Apply the Kafka files and wait until all components get into the Ready state
```shell
kubectl apply -f build/kafka
kubectl get pods -n kafka -w
```

When all kafka brokers are running the system under test and the load can be started
```shell
kubectl apply -f build/flink
kubectl apply -f build/load
kubectl get pods -n kafka -w
```
