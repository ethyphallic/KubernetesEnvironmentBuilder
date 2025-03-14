local imageProducer = import 'image-producer.jsonnet';

{
  eventFactory: {},
  imageProducer(definition, externalParameter): imageProducer.build(definition, externalParameter)
}