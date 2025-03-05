from prometheus_api_client import PrometheusConnect
from experiment_runner.aggregator.weighted_slo_aggregator import WeightedSloAggregator
from experiment_runner.k8s_client import K8sClient
from experiment_runner.mode.mode import ModeFullExperimentRun
from experiment_runner.query.query_accuracy import QueryAccuracy
from experiment_runner.query.query_consumer_group_lag import QueryIncomingMessages
from experiment_runner.query.query_energy_consumption import QueryEnergyConsumption
from experiment_runner.query.query_processing_latency import QueryProcessingLatency

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

    Scenario(
        slo_sinks=slo_sinks,
        duration=60,
        load_generator_delay=30,
        evaluation_delay=10,
        mode=ModeFullExperimentRun()
    ).run()

    print(latency_score_sink.get_score())
    print(accuracy_score_sink.get_score())
    aggregator = WeightedSloAggregator([latency_score_sink, accuracy_score_sink], [0.5, 0.5])
    print(aggregator.get_aggregated_score())
