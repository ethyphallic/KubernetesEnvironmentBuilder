### KUBERNETES ###
export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

alias k=kubectl
function kn() {
  kubectl get ns ; echo
  if [[ "$#" -eq 1 ]]; then
    kubectl config set-context --current --namespace $1 ; echo
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
  NAMESPACE=$(cat $DIR/config.json | jq .monitor.namespace)
  if [ -z $NAMESPACE ]; then
    echo "No namespace set in config.json"
    exit 1
  fi
  export PROMETHEUS_NODE_PORT=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-kube-prometheus-prometheus)
  export PROMETHEUS_URL="kube1-1:${PROMETHEUS_NODE_PORT}"
  echo "Prometheus url: $PROMETHEUS_URL"
}

function grafana() {
  NAMESPACE=$(cat $DIR/config.json | jq .monitor.namespace)
  if [ -z $NAMESPACE ]; then
    echo "No namespace set in config.json"
    exit 1
  fi
  $DIR/helm/monitor/build-grafana-dashboards.sh
  export GRAFANA_NODE_PORT=$(kubectl get --namespace $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-grafana)
  export GRAFANA_URL=kube1-1:$GRAFANA_NODE_PORT
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

function run() {
    python3 $DIR/main.py $1
}

function stop_load() {
    NAMESPACE=$(cat $DIR/config.json | jq .load.namespace)
    if [ -z $NAMESPACE ]; then
      echo "No namespace set in config.json"
      exit 1
    fi
    kubectl delete cm def-datasource -n $NAMESPACE
    kubectl delete cm def-load -n $NAMESPACE
    kubectl delete cm def-sink -n $NAMESPACE
    kubectl delete -f $DIR/build/load
}

function start_load() {
    NAMESPACE=$(cat $DIR/config.json | jq .load.namespace)
    if [ -z $NAMESPACE ]; then
      echo "No namespace set in config.json"
      exit 1
    fi
    kubectl create cm def-datasource --from-file $DIR/build/load/datasource -n $NAMESPACE
    kubectl create cm def-load --from-file $DIR/build/load/load -n $NAMESPACE
    kubectl create cm def-sink --from-file $DIR/build/load/sink -n $NAMESPACE
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
  NAMESPACE=$(cat $DIR/config.json | jq .kafka.namespace)
  if [ -z $NAMESPACE ]; then
    echo "No namespace set in config.json"
    exit 1
  fi
  kubectl delete pod -l name=strimzi-cluster-operator -n $NAMESPACE
}

function kafka() {
  NAMESPACE=$(cat $DIR/config.json | jq .kafka.namespace)
  if [ -z $NAMESPACE ]; then
    echo "No namespace set in config.json"
    exit 1
  fi
  export BOOTSTRAP_URL=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services power-kafka-external-bootstrap)
  echo "Kafka bootstrap server url: kube1-1:$BOOTSTRAP_URL"
}

function kafka_ui() {
  NAMESPACE=$(cat $DIR/config.json | jq .kafka.namespace)
  if [ -z $NAMESPACE ]; then
    echo "No namespace set in config.json"
    exit 1
  fi
  export KAFKA_UI_NODE_PORT=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services kafka-ui)
  export KAFKA_UI_URL=kube1-1:$KAFKA_UI_NODE_PORT
  echo "Kafka-UI url: $KAFKA_UI_URL"
}

function get_clusters() {
    k config get-contexts
}

function sc() {
  k config use-context $1
}

alias yaml2json="yq e -o=json | sed -E 's/\"(\w+)\":/\1:/'"
alias clip="xclip -selection clipboard"
alias pclip="xclip -o -selection clipboard"
alias y2j="pclip | yaml2json | clip"