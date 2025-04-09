{
  context: import 'config/context/cluster.json',
  monitor: import 'config/monitor/monitor.json',
  infra: {
    infra: import 'config/infra/infra.json',
    chaos: import 'config/infra/cpu-stress.json'
  },
  data: {
    kafka: import 'config/kafka/kafka.json',
    flink: import 'config/kafka/flink.json',
  },
  sut: {
    original: import 'config/sut/sut-flink.json',
    networkChaos: import 'config/sut/sut-object-classifier-patch.json',
    resourceChaos: import 'config/sut/sut-object-classifier-patch2.json'
  },
  load: {
    warmup: import 'config/load/load-image-producer-warmup.json',
    load: import 'config/load/load-image-producer.json',
  }
}