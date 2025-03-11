from prometheus_api_client import PrometheusConnect

from experiment_runner.query.query import Query
from experiment_runner.query.query_util import value_from_prometheus_result


class QueryEnergyConsumption(Query):
    def __init__(self, prometheus_connection):
        self.prometheus_connection = prometheus_connection

    def get_name(self):
        return "energy_consumption"

    def get_query_string(self):
        return ("sum(irate(kepler_container_dram_joules_total{pod_name=~'object-recognition.*'}[1m])) + sum(irate(kepler_container_package_joules_total{ pod_name=~'object-recognition.*'}[1m]))  + sum(irate(kepler_container_other_joules_total{ pod_name=~'object-recognition.*'}[1m]))")

    def execute(self):
        result = self.prometheus_connection.custom_query(self.get_query_string())
        if result:
            return (float(value_from_prometheus_result(result)))
        else:
            return -1

if __name__ == '__main__':
    q = QueryEnergyConsumption(PrometheusConnect(url="http://kube1-1:30920"))
    print(q.execute())