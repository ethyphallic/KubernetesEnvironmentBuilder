[ -d "build" ] && rm -r build
mkdir -p "build/flink"
mkdir -p "build/kafka"
mkdir -p "build/kafka-ui"
mkdir -p "build/load"
jsonnet -m k8s main.jsonnet
