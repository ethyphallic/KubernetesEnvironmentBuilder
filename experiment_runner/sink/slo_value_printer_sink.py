from experiment_runner.sink.slo_sink import SloSink

class SloValuePrinterSink(SloSink):

    def __init__(self, name):
        self.name: str = name

    def evaluate_slo(self, value, threshold, is_bigger_better):
        print(f"{self.name}: {value}")