local kafkaMain = import 'kafka/main-kafka.jsonnet';
local sutMain = import 'sut/main-sut.jsonnet';
local loadMain = import 'load/main-load.jsonnet';
local infraMain = import 'infra/main-infra.jsonnet';

{
  data: kafkaMain,
  sut: sutMain,
  load: loadMain,
  infra: infraMain
}