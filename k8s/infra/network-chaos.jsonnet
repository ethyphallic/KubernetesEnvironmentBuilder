{
    networkDelay(delayMs):: {
        apiVersion: "chaos-mesh.org/v1alpha1",
        kind: "NetworkChaos",
        metadata: {
           name: "delay"
        },
        spec: {
            action: "delay",
            mode: "one",
            selector: {
                namespaces: [
                    "sut"
                ],
            labelSelectors: {
                app: "heuristics-miner-flink"
            }
        },
            delay: {
                latency: "%sms" %[delayMs],
                correlation: "100",
                jitter: "0ms"
            }
        }
    }
}