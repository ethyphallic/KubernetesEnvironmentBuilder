helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts

docker run --rm --name jsonnet -v $(pwd)/../../global.jsonnet:/src/global.jsonnet -v $(pwd)/../../config.json:/src/config.json -v $(pwd):/src syseleven/jsonnet-builder -m . kafka-ui-values.jsonnet
helm install kafka-ui kafka-ui/kafka-ui -f kafka-ui-values.json -n kafka
sudo -- sh -c -e "rm kafka-ui-values.json config.json global.jsonnet"