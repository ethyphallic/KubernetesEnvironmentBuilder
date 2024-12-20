from abc import ABC, abstractmethod

class Query(ABC):

    @abstractmethod
    def get_query_string(self):
        pass