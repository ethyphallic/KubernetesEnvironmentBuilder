from time import sleep
from typing import Dict, List

from experiment_runner.ecoscape_client import EcoscapeClient
from experiment_runner.ecoscape_client_mode_aware import EcoscapeClientModeAware
from experiment_runner.sink.slo_sink import SloSink
from experiment_runner.slo import SLO

class Scenario:
    def __init__(
        self,
        duration,
        slo_sinks: Dict[SLO, List[SloSink]],
        ecoscape_client: EcoscapeClientModeAware,
        chaos_split = 0.25,
        evaluation_delay=30
    ):
        self.slo_sinks: Dict[SLO, List[SloSink]] = slo_sinks
        self.evaluation_delay = evaluation_delay
        self.duration = duration
        self.chaos_delay = int(chaos_split * duration)
        self.ecoscape_client = ecoscape_client

    def run_experiment(self):
        print(f"Wait {self.evaluation_delay} seconds until evaluation starts")
        for i in range(self.evaluation_delay):
            self._evaluate_slos(is_evaluation_phase=False)
        print("Evaluation starts")
        for i in range(int(self.chaos_delay)):
            self._evaluate_slos(is_evaluation_phase=True)

        self.ecoscape_client.apply_chaos()
        for i in range(self.duration - self.chaos_delay):
            self._evaluate_slos(is_evaluation_phase=True)
        self.ecoscape_client.delete_chaos()

    def _evaluate_slos(self, is_evaluation_phase):
        for slo in self.slo_sinks:
            value = slo.get_value()
            for slo_sink in self.slo_sinks[slo]:
                if is_evaluation_phase or slo_sink.is_monitor_sink:
                    slo_sink.evaluate_slo(value, slo.get_threshold(), slo.is_bigger_better)
        sleep(1)

    def run(self):
        print("start")
        try:
            self.ecoscape_client.deploy_sut()
            self.ecoscape_client.apply_infrastructure_constraints()
            self.ecoscape_client.start_load()
            self.run_experiment()
        except KeyboardInterrupt:
            print("program has been ended by user")
        self.ecoscape_client.stop_load()
        self.ecoscape_client.delete_infrastructure_constraints()
        self.ecoscape_client.remove_sut()
        print("end")