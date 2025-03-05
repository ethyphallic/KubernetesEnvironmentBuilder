from prometheus_api_client import PrometheusConnect
from experiment_runner.aggregator.weighted_slo_aggregator import WeightedSloAggregator
from experiment_runner.mode.mode import ModeFullExperimentRun
from experiment_runner.query.query_accuracy import QueryAccuracy
from experiment_runner.query.query_consumer_group_lag import QueryIncomingMessages
from experiment_runner.query.query_energy_consumption import QueryEnergyConsumption
from experiment_runner.query.query_processing_latency import QueryProcessingLatency
from argparse import ArgumentParser

from experiment_runner.scenario import Scenario, SLO
from experiment_runner.sink.slo_value_printer_sink import SloValuePrinterSink
from experiment_runner.sink.slo_violation_score_sink import SloViolationScoreSink

def query_registry():
    prometheus_connection = PrometheusConnect(url="http://kube1-1:30920")
    return {
        "energy": QueryEnergyConsumption(prometheus_connection),
        "lag": QueryIncomingMessages(prometheus_connection, "input"),
        "latency": QueryProcessingLatency(prometheus_connection),
        "accuracy": QueryAccuracy(prometheus_connection)
    }

def arg_or_default(arg, default):
    if arg:
        return arg
    return default

if __name__ == '__main__':
    queries = query_registry()

    slo_sinks = dict()
    latency_slo = SLO(queries["latency"], 5, False)
    accuracy_slo = SLO(queries["accuracy"], 0.75, True)

    latency_score_sink = SloViolationScoreSink(is_monitor_sink=False)
    accuracy_score_sink = SloViolationScoreSink(is_monitor_sink=False)
    latency_printer_sink = SloValuePrinterSink("Latency", True)
    accuracy_printer_sink = SloValuePrinterSink("Accuracy", True)

    slo_sinks[latency_slo] = [latency_score_sink, latency_printer_sink]
    slo_sinks[accuracy_slo] = [accuracy_score_sink, accuracy_printer_sink]

    argument_parser = ArgumentParser(description="Ecoscape")
    argument_parser.add_argument("--duration", type=int, help="experiment duration")
    argument_parser.add_argument("--load_delay", type=int, nargs='?', help="delay until the load generator starts")
    argument_parser.add_argument("--eval_delay", type=int, nargs='?', help="delay until the evaluation of the slo starts")
    argument_parser.add_argument("--repetitions", type=int, nargs='?', help="number of experiment runs")

    args = argument_parser.parse_args()
    print(arg_or_default(args.duration, 30))

    for i in range(arg_or_default(args.repetitions, 1)):
        Scenario(
            slo_sinks=slo_sinks,
            duration=arg_or_default(args.duration, 30),
            load_generator_delay=arg_or_default(args.load_delay, 30),
            evaluation_delay=arg_or_default(args.eval_delay, 15),
            mode=ModeFullExperimentRun()
        ).run()

    print(latency_score_sink.get_score())
    print(accuracy_score_sink.get_score())
    aggregator = WeightedSloAggregator([latency_score_sink, accuracy_score_sink], [0.5, 0.5])
    print(aggregator.get_aggregated_score())

