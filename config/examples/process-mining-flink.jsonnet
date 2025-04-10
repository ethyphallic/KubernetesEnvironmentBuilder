{
  context: import 'config/context/cluster.json',
  monitor: import 'config/monitor/monitor.json',
  infra: {
    infra: import 'config/infra/infra.json',
  },
  data: {
    kafka: import 'config/kafka/kafka.json',
    flink: import 'config/kafka/flink.json',
  },
  sut: {
    original: import 'config/sut/sut-flink.json',
  },
  load: {
    def: import 'config/load/load-def.json',
  }
}