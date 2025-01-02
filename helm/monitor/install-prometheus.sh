helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm uninstall prometheus -n monitor
helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-values.yaml --create-namespace --namespace monitor