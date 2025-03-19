### KUBERNETES ###
export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Helper function to load and check variables from the config.json file
check_config() {
  VAR=$(cat $DIR/config.json | jq -r "$1")
  if [ -z "$VAR" ] || [ "$VAR" == null ]; then
    echo "$1 not set in configuration file" >&2
    return 1
  fi
  echo $VAR
}

# Helper function to check current context and get the respected host address
check_context() {
  CONTEXT=$(kubectl config current-context)
  if [ -z "$CONTEXT" ]; then
    echo "Current context is empty. Please set a valid context."
    return 1
  fi
  if [ "$CONTEXT" = "minikube" ]; then
    echo $CONTEXT
  else
    echo $(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' | sed -E 's|https?://([^:/]+).*|\1|')
  fi
}

# Helper function to load specific namespaces from config
check_namespace() {
  PREFIX=$(check_config .context.prefix) || echo ""
  NAMESPACE=$(check_config $1) || return 1
  if [ -z "$PREFIX" ]; then
    echo "$NAMESPACE"
  else
    echo "$PREFIX-$NAMESPACE"
  fi
}

alias k=kubectl
function kn() {
  PREFIX=$(check_config .context.prefix) || echo ""
  if [ -z $1 ]; then
    # No argument given
    if [ ! -z "$PREFIX" ]; then
      echo "No namespace given, loading default prefix"
      NAMEPSACE=$PREFIX
    else
      echo "No namespace given" 
      return 1
    fi
  else
    # Argument given
    if [ ! -z "$PREFIX" ]; then
      NAMEPSACE="$PREFIX-$1"
    else
      NAMEPSACE="$1"
    fi
  fi
  echo "Loaded namespace name: $NAMEPSACE"
  kubectl get ns ; echo
  if [[ "$#" -eq 1 ]]; then
    kubectl config set-context --current --namespace $NAMEPSACE ; echo
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
  CONTEXT_URL=$(check_context) || return 1
  NAMESPACE=$(check_namespace .monitor.namespace) || return 1

  export PROMETHEUS_NODE_PORT=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-kube-prometheus-prometheus)
  export PROMETHEUS_URL="$CONTEXT_URL:${PROMETHEUS_NODE_PORT}"
  echo "Prometheus url: $PROMETHEUS_URL"
}

function grafana() {
  CONTEXT_URL=$(check_context) || return 1
  NAMESPACE=$(check_namespace .monitor.namespace) || return 1

  $DIR/helm/monitor/build-grafana-dashboards.sh
  export GRAFANA_NODE_PORT=$(kubectl get --namespace $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-grafana)
  export GRAFANA_URL=$CONTEXT_URL:$GRAFANA_NODE_PORT
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
    NAMESPACE=$(check_namespace .load.namespace) || return 1

    kubectl delete cm def-datasource -n $NAMESPACE
    kubectl delete cm def-load -n $NAMESPACE
    kubectl delete cm def-sink -n $NAMESPACE
    kubectl delete -f $DIR/build/load
}

function start_load() {
    NAMESPACE=$(check_namespace .load.namespace) || return 1

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
  NAMESPACE=$(check_namespace .kafka.namespace) || return 1
  kubectl delete pod -l name=strimzi-cluster-operator -n $NAMESPACE
}

function kafka() {
  CONTEXT_URL=$(check_context) || return 1
  NAMESPACE=$(check_namespace .kafka.namespace) || return 1
  export BOOTSTRAP_URL=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services power-kafka-external-bootstrap)
  echo "Kafka bootstrap server url: $CONTEXT_URL:$BOOTSTRAP_URL"
}

function kafka_ui() {
  CONTEXT_URL=$(check_context) || return 1
  NAMESPACE=$(check_namespace .kafka.namespace) || return 1
  export KAFKA_UI_NODE_PORT=$(kubectl get -n $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services kafka-ui)
  export KAFKA_UI_URL=$CONTEXT_URL:$KAFKA_UI_NODE_PORT
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