import time

from prometheus_api_client import PrometheusConnect
from experiment_runner.aggregator.weighted_slo_aggregator import WeightedSloAggregator
from experiment_runner.ecoscape_client import EcoscapeClient
from experiment_runner.ecoscape_client_mode_aware import EcoscapeClientModeAware
from experiment_runner.mode.mode import ModeFullExperimentRun
from experiment_runner.query.query_accuracy import QueryAccuracy
from experiment_runner.query.query_consumer_group_lag import QueryIncomingMessages
from experiment_runner.query.query_energy_consumption import QueryEnergyConsumption
from experiment_runner.query.query_processing_latency import QueryProcessingLatency
from argparse import ArgumentParser

from experiment_runner.scenario import Scenario, SLO
from experiment_runner.sink.slo_value_printer_sink import SloValuePrinterSink
from experiment_runner.sink.slo_violation_score_sink import SloViolationScoreSink
from experiment_runner.sink.slo_visualizer_sink import SloVisualizerSink


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
    energy_consumption = SLO(queries["energy"], 50, False)

    latency_score_sink = SloViolationScoreSink(is_monitor_sink=False)
    accuracy_score_sink = SloViolationScoreSink(is_monitor_sink=False)
    energy_score_sink = SloViolationScoreSink(is_monitor_sink=False)
    latency_printer_sink = SloValuePrinterSink("Latency", True)
    accuracy_printer_sink = SloValuePrinterSink("Accuracy", True)
    energy_printer_sink = SloValuePrinterSink("Energy", True)

    latency_visualizer_sink = SloVisualizerSink("Latency", False)
    accuracy_visualizer_sink = SloVisualizerSink("Accuracy", False)
    energy_visualizer_sink = SloVisualizerSink("Energy", False)

    slo_sinks[latency_slo] = [latency_score_sink, latency_printer_sink, latency_visualizer_sink]
    slo_sinks[accuracy_slo] = [accuracy_score_sink, accuracy_printer_sink, accuracy_visualizer_sink]
    slo_sinks[energy_consumption] = [energy_score_sink, energy_printer_sink, energy_visualizer_sink]

    argument_parser = ArgumentParser(description="Ecoscape")
    argument_parser.add_argument("--duration", type=int, help="experiment duration")
    argument_parser.add_argument("--load_delay", type=int, nargs='?', help="delay until the load generator starts")
    argument_parser.add_argument("--eval_delay", type=int, nargs='?',
                                 help="delay until the evaluation of the slo starts")
    argument_parser.add_argument("--repetitions", type=int, nargs='?', help="number of experiment runs")

    args = argument_parser.parse_args()
    load_delay = arg_or_default(args.load_delay, 30)
    repetitions = arg_or_default(args.repetitions, 1)

    client1 = EcoscapeClient("infra_builder/build")
    client2 = EcoscapeClient("infra_builder/build", operator_dir="operator2")
    client3 = EcoscapeClient("infra_builder/build", chaos_dir="chaos2")
    client4 = EcoscapeClient("infra_builder/build", operator_dir="operator2", chaos_dir="chaos2")

    for i in range(repetitions):
        Scenario(
            slo_sinks=slo_sinks,
            duration=arg_or_default(args.duration, 300),
            ecoscape_client=EcoscapeClientModeAware(
                mode=ModeFullExperimentRun(),
                load_generation_delay=load_delay,
                infra_delay=0.5 * load_delay,
                ecoscape_client=client2
            ),
            evaluation_delay=arg_or_default(args.eval_delay, 20),
        ).run()
        latency_visualizer_sink.start_new_experiment()
        accuracy_visualizer_sink.start_new_experiment()
        energy_visualizer_sink.start_new_experiment()
        print("Wait to start new exeriment")
        if i < repetitions-1:
            time.sleep(60)

    print(latency_score_sink.get_score())
    print(accuracy_score_sink.get_score())
    print(energy_score_sink.get_score())
    aggregator = WeightedSloAggregator([latency_score_sink, accuracy_score_sink, energy_score_sink], [0.3333, 0.3333, 0.3333])
    print(aggregator.get_aggregated_score())
    latency_visualizer_sink.save()
    accuracy_visualizer_sink.save()
    energy_visualizer_sink.save()
