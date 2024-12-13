helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm uninstall prometheus
helm install prometheus prometheus-community/kube-prometheus-stack --create-namespace --namespace monitoring