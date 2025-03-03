from abc import ABC, abstractmethod

class SloSink(ABC):

    @abstractmethod
    def evaluate_slo(self, value, threshold, is_bigger_better):
        pass