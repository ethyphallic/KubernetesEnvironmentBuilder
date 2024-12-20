{
    simulation(intensity, genTimeframesTilStart):: {
        kind: "simulation",
        name: "assembly-line-simulation",
        spec: {
            type: "loadTest",
            caseId: "increasing",
            genTimeframesTilStart: genTimeframesTilStart,
            load: {
                loadBehavior: "constant",
                load: intensity
            }
        }
    },
    sink(serviceDomainName, timeframe):: {
        kind: "sink",
        name: "http-sink",
        spec: {
            type: "http",
            id: "Sensor",
            timeframe: timeframe,
            url: "http://%s:8080/loadgenerator" % [serviceDomainName],
            dataSourceRefs: [
                "GoodsDelivery",
                "MaterialPreparation",
                "AssemblyLineSetup",
                "Assembling",
                "QualityControl",
                "Packaging",
                "Shipping"
            ]
        }
    }
}