import subprocess


class Load:

    def __init__(self, start_command, stop_command):
        self.start_command = start_command
        self.stop_command = stop_command

    def start(self):
        subprocess.run(self.start_command, shell=True)

    def stop(self):
        subprocess.run(self.stop_command, shell=True)
