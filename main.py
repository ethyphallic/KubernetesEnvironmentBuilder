from prometheus_api_client import PrometheusConnect
from experiment_runner.infra_transition import InfraTransition
from experiment_runner.load import Load
from experiment_runner.query.query_consumer_group_lag import QueryIncomingMessages
from experiment_runner.query.query_energy_consumption import QueryEnergyConsumption

from experiment_runner.scenario import Scenario, SLO
from experiment_runner.sut_deployment import SutDeployment

def query_registry():
    return {
        "energy": QueryEnergyConsumption(PrometheusConnect(url="http://minikube:30090")),
        "lag": QueryIncomingMessages(PrometheusConnect(url="http://minikube:30090"), "input")
    }

if __name__ == '__main__':
    query = query_registry()[
        "lag"
    ]

    Scenario(
        duration=60,
        slo=SLO(query, 0.5),
        load=Load(
            start_command='''
            kubectl create cm def-datasource --from-file k8s/build/load/datasource -n load
            kubectl create cm def-load --from-file k8s/build/load/load -n load
            kubectl create cm def-sink --from-file k8s/build/load/sink -n load
            kubectl apply -f $(pwd)/k8s/build/load''',
            stop_command='''
            kubectl delete deploy distributed-event-factory -n load
            kubectl delete deploy load-backend -n load
            '''
        ),
        infra_transitions=[
            #InfraTransition(name="pod-failure", start=5, end=15, start_action="kubectl apply -f k8s/build/chaos", end_action="kubectl delete -f k8s/build/chaos")
            InfraTransition(name="network-delay", start=5, end=15, start_action="kubectl apply -f k8s/build/chaos/network-failure.json", end_action="kubectl delete -f k8s/build/chaos/network-failure.json")
        ],
        sut_deployment=SutDeployment(
            deploy_command="kubectl apply -f k8s/build/sut",
            remove_command="kubectl delete -f k8s/build/sut"
        )
    ).run()

