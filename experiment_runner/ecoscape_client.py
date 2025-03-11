from experiment_runner.k8s_client import K8sClient

class EcoscapeClient:

    def __init__(
        self,
        base_dir,
        load_dir="load",
        sut_dir="sut",
        infra_dir="infra",
        chaos_dir="chaos",
        kafka_dir="kafka",
        operator_dir="operator"
    ):
        self.k8s_client:K8sClient = K8sClient()
        self.base_dir = base_dir
        self.load_dir = load_dir
        self.sut_dir = sut_dir
        self.infra_dir = infra_dir
        self.chaos_dir = chaos_dir
        self.kafka_dir = kafka_dir
        self.operator_dir = operator_dir

    def apply_load(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.load_dir)

    def stop_load(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.load_dir)

    def apply_sut(self):
        #self.k8s_client.create_directory(self.base_dir + "/" + self.sut_dir)
        self.k8s_client.create_directory(self.base_dir + "/" + self.operator_dir)
        self.k8s_client.create_directory(self.base_dir + "/" + self.kafka_dir)

    def delete_sut(self):
        #self.k8s_client.delete_directory(self.base_dir + "/" + self.sut_dir)
        self.k8s_client.delete_directory(self.base_dir + "/" + self.operator_dir)
        self.k8s_client.delete_directory(self.base_dir + "/" + self.kafka_dir)

    def apply_infra(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.infra_dir)

    def delete_infra(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.infra_dir)

    def apply_chaos(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.chaos_dir)

    def delete_chaos(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.chaos_dir)
