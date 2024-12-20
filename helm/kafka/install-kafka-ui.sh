helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts

jsonnet -m . kafka-ui-values.jsonnet
helm install kafka-ui kafka-ui/kafka-ui -f kafka-ui-values.json -n kafka
rm kafka-ui-values.json