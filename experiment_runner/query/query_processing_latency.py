from experiment_runner.query.query import Query
from experiment_runner.query.query_util import value_from_prometheus_result


class QueryProcessingLatency(Query):

    def __init__(self, prometheus_connection, pod):
        self.pod = pod
        self.prometheus_connection = prometheus_connection

    def get_name(self):
        return f"Query processing latency for pod {self.pod}"

    def execute(self):
        result = self.prometheus_connection.custom_query(f"latency{{pod='worker0-0'}}")
        if result:
            return float(value_from_prometheus_result(result))
        else:
            return -1