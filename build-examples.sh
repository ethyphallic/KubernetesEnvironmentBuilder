#!/bin/bash
(minikube status) || minikube start --memory 8192
helm/install-strimzi.sh
helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
helm install kafka-ui kafka-ui/kafka-ui -f examples/kafka-ui/values.json -n kafka
helm/install-prometheus.sh