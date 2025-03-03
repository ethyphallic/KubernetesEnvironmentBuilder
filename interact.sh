### KUBERNETES ###
export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

alias k=kubectl
function kn() {
  NS=$CLUSTER_PREFIX$1
  kubectl get ns ; echo
  if [[ "$#" -eq 1 ]]; then
    kubectl config set-context --current --namespace $NS ; echo
  fi
  echo "Current namespace [ $(kubectl config view --minify | grep namespace | cut -d " " -f6) ]"
}

### K9s ###
#wget https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_linux_amd64.deb && apt install ./k9s_linux_amd64.deb && rm k9s_linux_amd64.deb

function build() {
    chmod +x build-k8s.sh
    ./build-k8s.sh
    echo "Build Finished"
}

### MONITOR ###
function prometheus() {
  export PROMETHEUS_NODE_PORT=$(kubectl get -n monitor -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-kube-prometheus-prometheus)
  export PROMETHEUS_URL="minikube:${PROMETHEUS_NODE_PORT}"
  echo "Prometheus url: $PROMETHEUS_URL"
}

function grafana() {
  $DIR/helm/monitor/build-grafana-dashboards.sh
  export GRAFANA_NODE_PORT=$(kubectl get --namespace monitor -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-grafana)
  export GRAFANA_URL=minikube:$GRAFANA_NODE_PORT
  GRAFANA_PORT=$1
  if [ -z $1 ]; then
    GRAFANA_PORT=9091
  fi
  export GRAFANA_USERNAME=admin
  export GRAFANA_PASSWORD=prom-operator
  echo "Grafana url: ${GRAFANA_URL}"
  echo "Username: ${GRAFANA_USERNAME}"
  echo "Password: ${GRAFANA_PASSWORD}"
}

function ecoscape() {
    python3 $(pwd)/main.py $1
}

function stop_load() {
  kubectl delete cm def-datasource
  kubectl delete cm def-load
  kubectl delete cm def-sink
  kubectl delete -f $DIR/build/load
}

function start_load() {
    kubectl create cm def-datasource --from-file $DIR/build/load/datasource -n load
    kubectl create cm def-load --from-file $DIR/build/load/load -n load
    kubectl create cm def-sink --from-file $DIR/build/load/sink -n load
    kubectl apply -f $DIR/build/load
}

function start_chaos() {
    kubectl apply -f $DIR/build/chaos
}

function delete_chaos() {
    kubectl delete -f $DIR/build/chaos
}

function kafka_deploy() {
    kubectl apply -f $DIR/build/kafka
}

function kafka_destroy() {
    kubectl delete -f $DIR/build/kafka
}

function kafka_operator_restart() {
    kubectl delete pod -l name=strimzi-cluster-operator
}

function kafka() {
    export BOOTSTRAP_URL=$(kubectl get -n kafka -o jsonpath="{.spec.ports[0].nodePort}" services power-kafka-external-bootstrap)
    echo "Kafka bootstrap server url: minikube:$BOOTSTRAP_URL"
}

function kafka_ui() {
    export KAFKA_UI_NODE_PORT=$(kubectl get -n kafka -o jsonpath="{.spec.ports[0].nodePort}" services kafka-ui)
    export KAFKA_UI_URL=minikube:$KAFKA_UI_NODE_PORT
    echo "Kafka-UI url: $KAFKA_UI_URL"
}

function get_clusters() {
    k config get-contexts
}

function sc() {
  k config use-context $1
}

function cluster_prefix() {
    export CLUSTER_PREFIX=$1
}

alias yaml2json="yq e -o=json | sed -E 's/\"(\w+)\":/\1:/'"
alias clip="xclip -selection clipboard"
alias pclip="xclip -o -selection clipboard"
alias y2j="pclip | yaml2json | clip"
alias cpre=cluster_prefix