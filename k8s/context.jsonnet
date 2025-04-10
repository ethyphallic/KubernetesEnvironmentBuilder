#local config = import '../config/config.jsonnet';
#local config = import '../config/examples/process-mining-flink.jsonnet';
local config = import '../config/examples/object-recognition.jsonnet';
local functions = import 'functions.jsonnet';

{
    config: config,
    functions: functions(config)
}