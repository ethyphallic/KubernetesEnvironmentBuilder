import subprocess
from time import sleep
from typing import Dict, List

from experiment_runner.ecoscape_client import EcoscapeClient
from experiment_runner.mode.mode import Mode, ModeFullExperimentRun
from experiment_runner.sink.slo_sink import SloSink
from experiment_runner.slo import SLO

class Scenario:
    def __init__(
        self,
        duration,
        slos: Dict[SLO, List[SloSink]],
        infra_transitions,
        load_generator_delay,
        mode: Mode=ModeFullExperimentRun(),
        evaluation_delay=30
    ):
        self.slos: Dict[SLO, List[SloSink]] = slos
        self.slo_timeseries = dict()
        self.duration = duration
        self.infra_transitions = infra_transitions
        self.evaluation_delay = evaluation_delay
        self.load_generation_delay = load_generator_delay
        self.mode = mode
        self.ecoscape_client = EcoscapeClient("infra_builder/build")

    def _insert(self, dictionary: Dict, key, value):
        if key in dictionary:
            dictionary[key].append(value)
        else:
            dictionary[key] = [value]

    def _build_transition_dictionary(self) -> Dict[int, List[str]]:
        transitions = dict()
        for infra_transition in self.infra_transitions:
            self._insert(transitions, infra_transition.start, infra_transition.start_action)
            self._insert(transitions, infra_transition.end, infra_transition.end_action)
        return transitions

    def deploy_sut(self):
        if self.mode.is_deploy_system():
            self.ecoscape_client.deploy_sut()

    def remove_sut(self):
        if self.mode.is_deploy_system():
            self.ecoscape_client.delete_sut()

    def start_load(self):
        if self.mode.is_start_load():
            print(f"Wait {self.load_generation_delay}s to start the load")
            sleep(self.load_generation_delay)
            self.ecoscape_client.start_load()

    def stop_load(self):
        if self.mode.is_start_load():
            self.ecoscape_client.stop_load()

    def apply_transitions(self):
        print(f"Wait {self.evaluation_delay}s to start the evaluation")
        sleep(self.evaluation_delay)
        if self.mode.is_apply_transitions():
            transitions = self._build_transition_dictionary()
            for i in range(self.duration):
                if i in transitions:
                    for transition in transitions[i]:
                        print(transition)
                        subprocess.run(transition, shell=True)

                for slo in self.slos:
                    value = slo.get_value()
                    for slo_sink in self.slos[slo]:
                        slo_sink.evaluate_slo(value, slo.get_threshold(), slo.is_bigger_better)
                sleep(1)

    def run(self):
        print("start")
        try:
            self.deploy_sut()
            self.start_load()
            self.apply_transitions()
        except KeyboardInterrupt:
            print("program has been ended by user")
        except Exception as e:
            print("program failed")
            print(e)
        self.stop_load()
        self.remove_sut()
        sleep(45)
        self.ecoscape_client.delete_sut_phase2()
        print("end")