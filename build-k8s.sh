[ -d "build" ] && rm -r build
mkdir -p "build/flink"
mkdir -p "build/kafka"
mkdir -p "build/kafka-ui"
mkdir -p "build/load"
mkdir -p "build/load-config"
mkdir -p "build/load-config/datasource"
mkdir -p "build/load-config/load"
mkdir -p "build/load-config/sink"
mkdir -p "build/chaos"
jsonnet -m k8s main.jsonnet
