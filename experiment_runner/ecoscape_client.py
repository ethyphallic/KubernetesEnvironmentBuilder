from experiment_runner.k8s_client import K8sClient


class EcoscapeClient:

    def __init__(self, base_dir):
        self.k8s_client = K8sClient()
        self.base_dir = base_dir

    def start_load(self):
        self.k8s_client.create_directory(self.base_dir + "/load")

    def stop_load(self):
        self.k8s_client.delete_directory(self.base_dir + "/load")

    def deploy_sut(self):
        self.k8s_client.create_directory(self.base_dir + "/sut")
        self.k8s_client.create_directory(self.base_dir + "/kafka")

    def delete_sut(self):
        self.k8s_client.delete_directory(self.base_dir + "/sut")

    def delete_sut_phase2(self):
        self.k8s_client.delete_directory(self.base_dir + "/kafka")

    def deploy_infra(self):
        self.k8s_client.create_directory(self.base_dir + "/infra")

    def delete_infra(self):
        self.k8s_client.delete_directory(self.base_dir + "/infra")

if __name__ == '__main__':
    EcoscapeClient("../infra_builder/build").delete_sut()