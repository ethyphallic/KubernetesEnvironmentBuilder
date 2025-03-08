import matplotlib.pyplot as plt
from experiment_runner.sink.slo_sink import SloSink

class SloVisualizerSink(SloSink):

    def __init__(self, name, is_monitor_sink):
        super().__init__(is_monitor_sink)
        self.fig = plt.figure()
        self.name = name
        self.fig.canvas.manager.set_window_title(name)
        self.ax = self.fig.add_subplot()
        #self.ax2 = self.fig.add_subplot()
        self.i = 0
        self.x = []
        self.y = []
        self.y2 = []

    def evaluate_slo(self, value, threshold, is_bigger_better):
        self.x.append(self.i)
        self.y.append(value)
        self.y2.append(threshold)
        self.ax.plot(self.x, self.y, color='b')
        #self.ax2.plot(self.x, self.y2, color='r')
        self.fig.canvas.draw()
        self.fig.canvas.flush_events()
        plt.pause(1)
        self.i += 1

    def is_monitor_sink(self):
        return super().is_monitor_sink()

    def save(self):
        self.fig.savefig(f"{self.name}-plot.png")