DIR="$(dirname "$0")"

PREFIX=$(cat $DIR/../../config.json | jq -r .context.prefix)
NAMESPACE=$(cat $DIR/../../config.json | jq -r .monitor.namespace)
if [ -z $NAMESPACE ]; then
  echo "No explicit namespace set, trying prefix as namespace ..."
  if [ -z $PREFIX ]; then
    echo "Prefix also not set. Abort."
    exit 1
  else
    NAMESPACE=$PREFIX
  fi
else
  if [ -z $PREFIX ]; then
    NAMESPACE="$PREFIX-$NAMESPACE"
  fi
fi
echo "Selected namespace : $NAMESPACE"

kubectl -n $NAMESPACE create cm grafana-dpm-bench-dashboard --from-file=$DIR/../../k8s/monitor/dashboard/dpm-bench-dashboard.json
kubectl -n $NAMESPACE create cm grafana-kepler-dashboard --from-file=$DIR/../../k8s/monitor/dashboard/kepler-dashboard.json
kubectl -n $NAMESPACE label cm grafana-dpm-bench-dashboard grafana_dashboard="1"
kubectl -n $NAMESPACE label cm grafana-kepler-dashboard grafana_dashboard="1"
