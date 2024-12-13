kubectl delete cm def-datasource
kubectl delete cm def-load
kubectl delete cm def-sink

kubectl create cm def-datasource --from-file build/load-config/datasource
kubectl create cm def-load --from-file build/load-config/load
kubectl create cm def-sink --from-file build/load-config/sink

kubectl apply -f build/load