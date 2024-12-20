from experiment_runner.query.query import Query


class QueryConsumerGroupLag(Query):

    def __init__(self, topic):
        self.topic = topic

    def get_query_string(self):
        return f"sum by(topic) (kafka_server_brokertopicmetrics_messagesin_total{{topic='{self.topic}'}})"