from experiment_runner.k8s_client import K8sClient

class EcoscapeClient:

    def __init__(
        self,
        base_dir,
        load_dir="load",
        sut_dir="sut0",
        sut_patch_dir="sut1",
        infra_dir="infra",
        monitor_dir="monitor",
        chaos_dir="chaos"
    ):
        self.k8s_client:K8sClient = K8sClient()
        self.base_dir = base_dir
        self.load_dir = load_dir
        self.sut_dir = sut_dir
        self.sut_patch_dir = sut_patch_dir
        self.infra_dir = infra_dir
        self.monitor_dir = monitor_dir
        self.chaos_dir = chaos_dir

    def apply_load(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.load_dir)

    def stop_load(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.load_dir)

    def apply_sut(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.sut_dir)

    def apply_patched_sut(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.sut_patch_dir)

    def delete_sut(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.sut_dir)

    def delete_patched_sut(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.sut_patch_dir)

    def apply_infra(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.infra_dir)
        self.k8s_client.create_directory(self.base_dir + "/" + self.monitor_dir)
        self.k8s_client.create_directory(self.base_dir + "/" + self.monitor_dir + "/podmonitor")

    def delete_infra(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.infra_dir)
        self.k8s_client.delete_directory(self.base_dir + "/" + self.monitor_dir)

    def apply_chaos(self):
        self.k8s_client.create_directory(self.base_dir + "/" + self.chaos_dir)

    def delete_chaos(self):
        self.k8s_client.delete_directory(self.base_dir + "/" + self.chaos_dir)
