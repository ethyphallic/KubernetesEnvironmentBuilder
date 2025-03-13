DIR="$(dirname "$0")"
NAMESPACE=$(cat $DIR/../../config.json | jq .monitor.namespace)
if [ -z $NAMESPACE ]; then
  echo "No namespace set in config.json"
  exit 1
fi
kubectl -n $NAMESPACE create cm grafana-dpm-bench-dashboard --from-file=$DIR/../../k8s/monitor/dashboard/dpm-bench-dashboard.json
kubectl -n $NAMESPACE create cm grafana-kepler-dashboard --from-file=$DIR/../../k8s/monitor/dashboard/kepler-dashboard.json
kubectl -n $NAMESPACE label cm grafana-dpm-bench-dashboard grafana_dashboard="1"
kubectl -n $NAMESPACE label cm grafana-kepler-dashboard grafana_dashboard="1"
