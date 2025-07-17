import numpy as np

from experiment_runner.sink.slo_violation_score_sink import SloViolationScoreSink

if __name__ == '__main__':
    #prefix = "mhpzt"
    prefix = "hhkag"

    # Sample data
    x0 = np.loadtxt(f"result/{prefix}-latency.csv", delimiter=',')
    x1 = np.loadtxt(f"result/{prefix}-energy.csv", delimiter=',')
    x2 = np.loadtxt(f"result/{prefix}-accuracy.csv", delimiter=',')

    score_latency = SloViolationScoreSink(False)
    score_energy = SloViolationScoreSink(False)
    score_accuracy = SloViolationScoreSink(False)
    for x in x0[60:]:
        score_latency.evaluate_slo(x, 2.5, False)

    for x in x1[60:]:
        score_energy.evaluate_slo(x, 120, False)

    for x in x2[60:]:
        score_accuracy.evaluate_slo(0.75-x, 0.75, False)

    print(score_latency.get_score())
    print(score_energy.get_score())
    print(score_accuracy.get_score())

    print(0.5*score_latency.get_score() + 0.25*score_energy.get_score() + 0.25*score_accuracy.get_score())