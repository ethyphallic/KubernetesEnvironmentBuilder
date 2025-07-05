import time

from experiment_runner.k8s_client import K8sClient

class OperatorCore:

    def __init__(self, reaction_delay, base_directory, patch_directory, elasticity_time):
        self.k8s_client: K8sClient = K8sClient()
        self.reaction_delay = reaction_delay
        self.base_directory = base_directory
        self.patch_directory = patch_directory
        self.elasticity_time = elasticity_time

    def run(self):
        print(f"Wait {self.reaction_delay} until system is patched")
        time.sleep(self.reaction_delay)
        self.k8s_client.apply_directory(self.patch_directory, is_delete=False)
        print(f"Wait {self.reaction_delay} until system is rolled")
        time.sleep(self.elasticity_time)
        self.k8s_client.apply_directory(self.base_directory, is_delete=True)