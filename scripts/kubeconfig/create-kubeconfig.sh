NAMESPACE=$(cat ../../build/cluster-config.json | jq -r .prefix)

TOKEN=$(kubectl get secret token-secret-sa-$NAMESPACE -n ${NAMESPACE}-default -ojsonpath={.data.token} | base64 -d)
CA_CERT=$(kubectl get secret token-secret-sa-$NAMESPACE -n ${NAMESPACE}-default -ojsonpath={.data.'ca\.crt'})

touch $NAMESPACE.txt
(jsonnet kubeconfig.jsonnet --ext-str username=$NAMESPACE --ext-str token=$TOKEN --ext-str caCert=$CA_CERT) > $NAMESPACE.txt