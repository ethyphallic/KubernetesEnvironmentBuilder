function(intensity, genTimeframesTilStart) {
    kind: "simulation",
    name: "assembly-line-simulation",
    spec: {
        type: "loadTest",
        caseId: "increasing",
        maxConcurrentCases: 1,
        genTimeframesTilStart: genTimeframesTilStart,
        load: {
            loadBehavior: "constant",
            load: intensity
        }
    }
}