kubectl -n monitor create cm grafana-dpm-bench-dashboard --from-file=k8s/dashboard/dpm-bench-dashboard.json
kubectl -n monitor create cm grafana-kepler-dashboard --from-file=k8s/dashboard/kepler-dashboard.json
kubectl -n monitor label cm grafana-dpm-bench-dashboard grafana_dashboard="1"
kubectl -n monitor label cm grafana-kepler-dashboard grafana_dashboard="1"
