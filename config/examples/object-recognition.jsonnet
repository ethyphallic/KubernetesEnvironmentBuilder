{
  context: import '../context/cluster.json',
  monitor: import '../monitor/monitor.json',
  infra: {
    infra: import '../infra/infra.json',
    chaos: import '../infra/cpu-stress.json'
  },
  data: {
    kafka: import '../kafka/kafka.json'
  },
  sut: {
    original: import '../sut/sut-object-classifier.json',
    networkChaos: import '../sut/sut-object-classifier-patch.json',
    resourceChaos: import '../sut/sut-object-classifier-patch2.json'
  },
  load: {
    warmup: import '../load/load-image-producer-warmup.json',
    load: import '../load/load-image-producer.json',
  }
}