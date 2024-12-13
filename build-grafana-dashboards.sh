kubectl -n monitoring create cm grafana-dpm-bench-dashboard --from-file=k8s/dashboard/dpm-bench-dashboard.json
kubectl -n monitoring label cm grafana-dpm-bench-dashboard grafana_dashboard="1"
