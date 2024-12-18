kubectl delete cm def-datasource > /dev/null
kubectl delete cm def-load > /dev/null
kubectl delete cm def-sink > /dev/null

kubectl create cm def-datasource --from-file build/load-config/datasource -n kafka
kubectl create cm def-load --from-file build/load-config/load -n kafka
kubectl create cm def-sink --from-file build/load-config/sink -n kafka

kubectl apply -f build/load