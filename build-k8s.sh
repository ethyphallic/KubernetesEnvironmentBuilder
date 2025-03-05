[ -d "build" ] && sudo -- sh -c -e "rm -r build"
mkdir -p "build/cluster"
mkdir -p "build/cluster/namespace"
mkdir -p "build/sut"
mkdir -p "build/kafka"
mkdir -p "build/load"
mkdir -p "build/load/datasource"
mkdir -p "build/load/load"
mkdir -p "build/load/sink"
mkdir -p "build/chaos"
mkdir -p "build/infra"
mkdir -p "build/monitor"
jsonnet -m . k8s/main.jsonnet
#docker run --rm --name jsonnet -v $(pwd):/src syseleven/jsonnet-builder -m . k8s/main.jsonnet
