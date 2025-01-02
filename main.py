from experiment_runner.experiment import Experiment
from experiment_runner.prometheus_probe import PrometheusProbe
from experiment_runner.query.query_consumer_group_lag import QueryConsumerGroupLag

if __name__ == '__main__':
    Experiment(PrometheusProbe(), prometheus_query=QueryConsumerGroupLag(topic="input")).execute_continuously()