import subprocess
from time import sleep
from typing import Dict, List

from experiment_runner.mode.mode import Mode, ModeFullExperimentRun

class SLO:
    def __init__(self, query, threshold):
        self.query = query
        self.threshold = threshold

    def get_value(self) -> float:
        return self.query.execute()

    def is_uphold(self) -> bool:
        query_result = self.query.execute()
        is_uphold = query_result < self.threshold
        print(f"{query_result} ({is_uphold})" )
        return is_uphold

class Scenario:
    def __init__(
            self,
            duration,
            slo: SLO,
            load,
            infra_transitions,
            sut_deployment,
            mode: Mode=ModeFullExperimentRun(),
            load_generator_delay=15,
    ):
        self.slo = slo
        self.slo_timeseries = []
        self.duration = duration
        self.load = load
        self.infra_transitions = infra_transitions
        self.load_generator_delay = load_generator_delay
        self.sut_deployment = sut_deployment
        self.mode = mode

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
            self.sut_deployment.deploy()

    def remove_sut(self):
        if self.mode.is_deploy_system():
            self.sut_deployment.remove()

    def start_load(self):
        print(f"Wait {self.load_generator_delay} seconds until load starts")
        sleep(self.load_generator_delay)
        if self.mode.is_start_load():
            self.load.start()

    def stop_load(self):
        if self.mode.is_start_load():
            self.load.stop()

    def apply_transitions(self):
        if self.mode.is_apply_transitions():
            transitions = self._build_transition_dictionary()
            for i in range(self.duration):
                if i in transitions:
                    for transition in transitions[i]:
                        print(transition)
                        subprocess.run(transition, shell=True)
                self.slo.is_uphold()
                self.slo_timeseries.append(self.slo.get_value())
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
        print(sum(self.slo_timeseries) / len(self.slo_timeseries))
        print("end")