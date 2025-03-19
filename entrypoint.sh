#!/bin/bash

# Create a container-friendly kubeconfig
mkdir -p /tmp/.kube
cp /root/.kube/config /tmp/.kube/config

# Check if config contains minikube references
if grep -q "minikube" /tmp/.kube/config; then
  echo "Detected minikube configuration"
  
  # Check if .minikube directory is mounted
  if [ ! -d "/root/.minikube" ]; then
    echo "Warning: .minikube directory is not mounted. You may need to restart the container."
  fi
  
  # Replace Windows paths with Linux paths in the temporary kubeconfig
  # Handle different possible formats
  sed -i "s|https://127.0.0.1|https://host.docker.internal|g" /tmp/.kube/config
  sed -i '/^\s*server: https:\/\/host\.docker\.internal/,/^\s*[^[:space:]]/ s/^\s*server:/    insecure-skip-tls-verify: true\n    server:/' /tmp/.kube/config
  sed -i '/^\s*certificate-authority/d' /tmp/.kube/config
  sed -i 's|C:\\Users\\[^\\]*\\.minikube|/root/.minikube|g' /tmp/.kube/config
  sed -i 's|C:/Users/[^/]*/.minikube|/root/.minikube|g' /tmp/.kube/config
  sed -i 's|\\|/|g' /tmp/.kube/config

  # Use the modified config
  export KUBECONFIG=/tmp/.kube/config
  echo "Using modified kubeconfig at $KUBECONFIG (Minikube)"
fi

# Test connection
echo "Testing kubectl connection..."
if kubectl get pods > /dev/null 2>&1; then
  echo "✅ Kubernetes connection successful"
  echo "You can now use kubectl, helm, and other Kubernetes tools"
else
  echo "⚠️ Could not connect to Kubernetes cluster"
  echo "You may need to check your configuration or permissions on the cluster"
fi