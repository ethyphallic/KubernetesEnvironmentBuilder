#!/bin/bash
kubectl create namespace kafka
helm install kafka-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator -n kafka