### KUBERNETES ###
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
    ./build-k8s.sh > /dev/null
    echo "Build Finished"
}

### MONITOR ###
function prometheus() {
  chmod +x helm/expose-prometheus-nodeport.sh
  ./helm/expose-prometheus-nodeport.sh
  PROMETHEUS_PORT=$1
  if [ -z $1 ]; then
    PROMETHEUS_PORT=9090
  fi
  export PROMETHEUS_NODE_PORT=$(kubectl get --namespace monitor -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-nodeport-service)
  export PROMETHEUS_URL="minikube:${PROMETHEUS_NODE_PORT}"
  echo "Prometheus url: $PROMETHEUS_URL"
}

function grafana() {
  ./build-grafana-dashboards.sh
  ./helm/expose-grafana-nodeport.sh
  export GRAFANA_NODE_PORT=$(kubectl get --namespace monitor -o jsonpath="{.spec.ports[0].nodePort}" services grafana-nodeport-service)
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

### KAFKA ###
export KAFKA_UI_NODE_PORT=$(kubectl get --namespace kafka -o jsonpath="{.spec.ports[0].nodePort}" services kafka-ui)
export KAFKA_UI_URL=minikube:$KAFKA_UI_NODE_PORT

function run() {
    python3 $(pwd)/main.py
}

function stop_load() {
  kubectl delete deploy distributed-event-factory -n kafka
  kubectl delete deploy load-backend -n kafka
}

function start_load() {
    kubectl apply -f $(pwd)/k8s/build/load
}