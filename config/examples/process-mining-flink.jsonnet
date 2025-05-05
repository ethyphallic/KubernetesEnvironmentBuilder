{
  context: import '../context/cluster.json',
  monitor: import '../monitor/monitor.json',
  infra: {
    infra: import '../infra/infra.json',
  },
  data: {
    kafka: import '../kafka/kafka.json',
    flink: import '../kafka/flink.json',
  },
  sut: {
    original: import '../sut/sut-flink.json',
  },
  load: {
    def: import '../load/load-def.json',
  }
}