#!/bin/bash
(minikube status) || minikube start --memory 8192
helm/install-strimzi.sh
./build-k8s.sh
helm/install-kafka-ui.sh
helm/install-prometheus.sh