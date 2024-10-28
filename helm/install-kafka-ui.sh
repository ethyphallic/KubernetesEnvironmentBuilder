helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
if [ -d build/kafka-ui ]; then
  helm install kafka-ui kafka-ui/kafka-ui -f build/kafka-ui/values.json -n kafka
else
  echo "Please run the build build-k8s.sh script before"
fi