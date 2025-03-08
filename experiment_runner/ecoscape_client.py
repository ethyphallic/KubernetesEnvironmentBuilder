from experiment_runner.k8s_client import K8sClient

class EcoscapeClient:

    def __init__(self, base_dir):
        self.k8s_client:K8sClient = K8sClient()
        self.base_dir = base_dir

    def apply_load(self):
        self.k8s_client.create_directory(self.base_dir + "/load")

    def stop_load(self):
        self.k8s_client.delete_directory(self.base_dir + "/load")

    def apply_sut(self):
        self.k8s_client.create_directory(self.base_dir + "/sut")
        self.k8s_client.create_directory(self.base_dir + "/kafka")

    def delete_sut(self):
        self.k8s_client.delete_directory(self.base_dir + "/sut")
        self.k8s_client.delete_directory(self.base_dir + "/kafka")

    def apply_infra(self):
        self.k8s_client.create_directory(self.base_dir + "/infra")

    def delete_infra(self):
        self.k8s_client.delete_directory(self.base_dir + "/infra")

    def apply_chaos(self):
        self.k8s_client.create_directory(self.base_dir + "/chaos")

    def delete_chaos(self):
        self.k8s_client.delete_directory(self.base_dir + "/chaos")
