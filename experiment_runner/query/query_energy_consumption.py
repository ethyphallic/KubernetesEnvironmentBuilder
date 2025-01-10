from experiment_runner.query.query import Query


class QueryEnergyConsumption(Query):
    def __init__(self, prometheus_connection):
        self.prometheus_connection = prometheus_connection

    def get_name(self):
        return "Cpu Energy Consumption"

    def get_query_string(self):
        return "sum by (pod_name, container_namespace) (irate(kepler_container_package_joules_total{container_namespace=~'kafka', pod_name=~'power-kafka-0'}[1m]))"

    def execute(self):
        return float(self.prometheus_connection.custom_query("sum by (pod_name, container_namespace) (irate(kepler_container_package_joules_total{container_namespace=~'kafka', pod_name=~'power-kafka-0'}[1m]))")[0]["value"][1])