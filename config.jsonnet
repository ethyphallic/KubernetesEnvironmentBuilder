{
  context: import 'config/context/cluster.json',
  infra: import 'config/infra/infra.json',
  monitor: import 'config/monitor/monitor.json',
  kafka: import 'config/kafka/kafka.json',
  sut0: import 'config/sut/sut-object-classifier.json',
  sut1: import 'config/sut/sut-object-classifier-patch.json',
  warmup: import 'config/load/load-image-producer-warmup.json',
  load: import 'config/load/load-image-producer.json',
  #chaos: import 'config/infra/chaos.json',
}