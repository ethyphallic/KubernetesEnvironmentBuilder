kubectl delete cm def-datasource -n load > /dev/null
kubectl delete cm def-load -n load > /dev/null
kubectl delete cm def-sink -n load > /dev/null

kubectl create cm def-datasource --from-file build/load-config/datasource -n load
kubectl create cm def-load --from-file build/load-config/load -n load
kubectl create cm def-sink --from-file build/load-config/sink -n load

kubectl apply -f build/load