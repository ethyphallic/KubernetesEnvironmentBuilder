{
  all(): [
    $.startSensor(),
    $.goodsDelivery(),
    $.materialPreparation(),
    $.assemblyLineSetup(),
    $.qualityControl(),
    $.packaging(),
    $.shipping()
  ],
  startSensor():: {
    kind: "datasource",
    name: "<start>",
    spec: {
      name: "<start>",
      group: "factory",
      selection: "genericProbability",
      distribution: [1],
      eventData: [
        {
          activity: "",
          transition: "GoodsDelivery",
          duration: 0
        }
      ]
    }
  },
  goodsDelivery():: {
    kind: "datasource",
    name: "GoodsDelivery",
    spec: {
      name: "GoodsDelivery",
      group: "factory",
      selection: "driftingProbability",
      startDistribution: ["0.1", "0.7", "0.2"],
      endDistribution: ["0.1", "0.2", "0.7"],
      steps: 1000,
      eventData: [
        {
          activity: "Reject",
          transition: "<end>",
          duration: 1
        },
        {
          activity: "Store",
          transition: "GoodsDelivery",
          duration: {
            type: "gaussian",
            mu: 720,
            sigma: 120
          }
        },
        {
          activity: "Pass To Production",
          transition: "MaterialPreparation",
          duration: {
            type: "uniform",
            lowerBound: 3,
            upperBound: 7
          }
        }
      ]
    }
  },
  materialPreparation():: {
    kind: "datasource",
    name: "MaterialPreparation",
    spec: {
      name: "MaterialPreparation",
      group: "factory",
      selection: "genericProbability",
      distribution: ["0.25","0.7","0.05"],
      eventData: [
        {
          activity: "MaterialPreparation - Finished",
          duration: {
            type: "uniform",
            lowerBound: 1,
            upperBound: 2
          },
          transition: "AssemblyLineSetup"
        },
        {
          activity: "Waiting for Material",
          transition: "MaterialPreparation",
          duration: 1
        },
        {
          activity: "Internal Error",
          transition: "MaterialPreparation",
          duration: {
            type: "gaussian",
            mu: 500,
            sigma: 100
          }
        }
      ]
    }
  },
  assemblyLineSetup():: {
    kind: "datasource",
    name: "AssemblyLineSetup",
    spec: {
      name: "AssemblyLineSetup",
      group: "factory",
      selection: "genericProbability",
      distribution: ["0.3","0.4","0.15","0.05","0.1"],
      eventData: [
        {
          activity: "Material Not Set Up as expected",
          transition: "MaterialPreparation",
          duration: {
            type: "uniform",
            lowerBound: 2,
            upperBound: 5
          }
        },
        {
          activity: "Assembly Line Setup successfully",
          transition: "Assembling",
          duration: 3
        },
        {
          activity: "Material in wrong order. Reordering..",
          transition: "AssemblyLineSetup",
          duration: 1
        },
        {
          activity: "Maximum Material count exceeded. Remove item",
          transition: "AssemblyLineSetup",
          duration: 1
        },
        {
          activity: "Internal Error",
          transition: "Assembling",
          duration: {
            type: "gaussian",
            mu: 500,
            sigma: 100
          }
        }
      ]
    }
  },
  assembling(): {
    kind: "datasource",
    name: "Assembling",
    spec: {
      name: "Assembling",
      group: "factory",
      selection: "genericProbability",
      distribution: ["0.8", "0.1", "0.08", "0.02"],
      eventData: [
        {
          activity: "Assembling completed",
          duration: 10,
          transition: "QualityControl"
        },
        {
          activity: "Overheating",
          transition: "<end>",
          duration: 2
        },
        {
          activity: "Item broke",
          transition: "<end>",
          duration: 1
        },
        {
          activity: "Internal Error",
          transition: "Assembling",
          duration: {
            type: "gaussian",
            mu: 500,
            sigma: 100
          }
        }
      ]
    }
  },
  qualityControl():: {
    kind: "datasource",
    name: "QualityControl",
    spec: {
      name: "QualityControl",
      group: "factory",
      selection: "genericProbability",
      distribution: ["0.3", "0.1", "0.6"],
      eventData: [
        {
          activity: "Item Needs Corrections",
          transition: "Assembling",
          duration: 2
        },
        {
          activity: "Quality Insufficient",
          transition: "<end>",
          duration: 2
        },
        {
          activity: "Quality check passed",
          transition: "Packaging",
          duration: {
            type: "uniform",
            lowerBound: 5,
            upperBound: 10
          }
        }
      ]
    }
  },
  packaging():: {
    kind: "datasource",
    name: "Packaging",
    spec: {
      name: "Packaging",
      group: "factory",
      selection: "genericProbability",
      distribution: ["1.0"],
      eventData: [
        {
          activity: "Packaging completed",
          transition: "Shipping",
          duration: 3
        }
      ]
    }
  },
  shipping():: {
    kind: "datasource",
    name: "Shipping",
    spec: {
      name: "Shipping",
      group: "factory",
      selection: "genericProbability",
      distribution: ["0.8", "0.2"],
      eventData: [
        {
          activity: "Package waits for sending",
          transition: "Shipping",
          duration: 180
        },
        {
          activity: "Package sent",
          transition: "<end>",
          duration: 1
        }
      ]
    }
  }
}