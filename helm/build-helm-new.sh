CONTEXT=$(kubectl config current-context)
DIR="$(dirname "$0")"

if [[ -z $1 ]]
then
  CONFIG_NAME=minikube
else
 CONFIG_NAME=$1
fi

function check_enabled() {
  echo $1
  [ "$(cat $DIR/../config/context/$CONFIG_NAME.json | jq .operator.$1)" == "true" ]
}

kubectl get ns operator>/dev/null || kubectl create ns operator

(check_enabled prometheus \
 && helm repo add prometheus-community https://prometheus-community.github.io/helm-charts \
 && helm install prometheus prometheus-community/kube-prometheus-stack --values monitor/prometheus-operator-values.yaml -n operator
)

(check_enabled strimzi \
 && helm install kafka-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator -n operator
)

(check_enabled chaosMesh \
 && helm repo add chaos-mesh https://charts.chaos-mesh.org \
 && helm install chaos-mesh chaos-mesh/chaos-mesh -n operator
)

(check_enabled kepler \
 && helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart \
 && helm install kepler kepler/kepler --set serviceMonitor.enabled=true --set serviceMonitor.labels.release=prometheus -n operator
)




