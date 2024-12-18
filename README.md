minikube s# Installation Guide for Kafka on Kubernetes

First install the following programs: 
- [minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/)
- [helm](https://helm.sh/docs/intro/install/) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

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
chmod +x build-examples.sh
./build-examples.sh
```

Apply the Kafka files and wait until all components get into the `Running` state
```shell
kubectl apply -f examples/kafka
kubectl get pods -n kafka -w
```

```shell
source interact.sh
```