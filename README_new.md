```bash
cd helm && ./build-helm.sh
```

```bash
cd ../k8s && ./build-k8s.sh
```

```bash
kubectl apply -f build/kafka
```

```bash
kubectl apply -f build/flink
```

```bash
cd .. && source interact.sh
start_load
```

