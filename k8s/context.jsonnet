local config = import '../config.jsonnet';
local functions = import 'functions.jsonnet';

{
    config: config,
    functions: functions(config)
}