import subprocess

class SutDeployment:

    def __init__(self, deploy_command, remove_command):
        self.deploy_command = deploy_command
        self.remove_command = remove_command

    def deploy(self):
        subprocess.run(self.deploy_command, shell=True)

    def remove(self):
        subprocess.run(self.remove_command, shell=True)
