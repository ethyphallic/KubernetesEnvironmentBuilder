from prometheus_api_client import PrometheusConnect
from experiment_runner.infra_transition import InfraTransition
from experiment_runner.load import Load
from experiment_runner.query.query import Query
from experiment_runner.query.query_consumer_group_lag import QueryIncomingMessages
from experiment_runner.query.query_energy_consumption import QueryEnergyConsumption
from experiment_runner.query.query_processing_latency import QueryProcessingLatency

from experiment_runner.scenario import Scenario, SLO
from experiment_runner.sut_deployment import SutDeployment

def query_registry():
    prometheus_connection = PrometheusConnect(url="http://minikube:30090")
    return {
        "energy": QueryEnergyConsumption(prometheus_connection),
        "lag": QueryIncomingMessages(prometheus_connection, "input"),
        "processing_latency": QueryProcessingLatency(prometheus_connection, "worker-0")
    }

if __name__ == '__main__':
    query: Query = query_registry()["processing_latency"]
    print(query.execute())

    Scenario(
        duration=120,
        slo=SLO(query, 3000),
        load=Load(
            start_command="kubectl apply -f infra_builder/build/load",
            stop_command="kubectl delete -f infra_builder/build/load"
        ),
        infra_transitions=[],
        sut_deployment=SutDeployment(
            deploy_command="kubectl apply -f infra_builder/build/sut",
            remove_command="kubectl delete -f infra_builder/build/sut"
        ),
        load_generator_delay=60
    ).run()