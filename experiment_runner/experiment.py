from time import sleep

from experiment_runner.prometheus_probe import PrometheusProbe
from experiment_runner.query.query import Query


class Experiment:

    def __init__(self, prometheus_probe, prometheus_query):
        self.prometheus_probe: PrometheusProbe = prometheus_probe
        self.prometheus_query: Query = prometheus_query

    def execute_continuously(self, duration=60):
        for i in range(duration):
            self.prometheus_probe.execute_query(self.prometheus_query.get_query_string())
            sleep(5)