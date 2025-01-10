[ -d "build" ] && rm -r build
mkdir -p "build/sut"
mkdir -p "build/kafka"
mkdir -p "build/load"
mkdir -p "build/load/datasource"
mkdir -p "build/load/load"
mkdir -p "build/load/sink"
mkdir -p "build/chaos"
mkdir -p "build/monitor"
#docker run --rm --name jsonnet -v $(pwd):/src syseleven/jsonnet-builder -m . main.jsonnet
jsonnet -m . main.jsonnet