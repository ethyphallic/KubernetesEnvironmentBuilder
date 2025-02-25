ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  kubectl -n scalablemine-$ID-monitor create cm grafana-dpm-bench-dashboard --from-file=k8s/monitor/dashboard/dpm-bench-dashboard.json
  kubectl -n scalablemine-$ID-monitor create cm grafana-kepler-dashboard --from-file=k8s/monitor/dashboard/kepler-dashboard.json
  kubectl -n scalablemine-$ID-monitor label cm grafana-dpm-bench-dashboard grafana_dashboard="1"
  kubectl -n scalablemine-$ID-monitor label cm grafana-kepler-dashboard grafana_dashboard="1"
fi
