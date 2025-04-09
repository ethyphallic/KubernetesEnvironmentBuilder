import matplotlib.pyplot as plt
import numpy as np

if __name__ == '__main__':
    #prefix = "hwkds" #CPU stress
    #prefix = "dgtze" #Network stress
    prefix = "mhpzt"
    #prefix = "hhkag"

    # Sample data
    x0 = np.loadtxt(f"result/{prefix}-latency.csv", delimiter=',')
    x1 = np.loadtxt(f"result/{prefix}-energy.csv", delimiter=',')
    x2 = np.loadtxt(f"result/{prefix}-accuracy.csv", delimiter=',')
    x3 = [0]*len(x0)

    # Create the plot
    plt.plot(5*(((0.75-x2[45:])/0.75)), label="accuracy", linestyle="-.")
    plt.plot( 1*((x1[45:]/120) - 1), label="energy"  , linestyle="-.")
    plt.plot( 1*((x0[45:]/2.5) - 1), label="latency" , linestyle="-")
    plt.plot(x3[45:], linestyle="-", label="slo baseline", color="darkgrey")

    # Add labels and title
    plt.axvline(x=15, color='r', linestyle=":")
    plt.axvline(x=45, color='r', linestyle=":")
    plt.axvline(x=60, color='r', linestyle=":")

    plt.xlabel("time in seconds [s]")
    plt.ylabel("Ratio of SLO violation")
    plt.title("Scenario: CPU stress")
    #plt.title("Scenario: Network Latency")

    plt.legend()
    # Display the plot
    plt.savefig(f'result/plot-{prefix}.pdf', bbox_inches='tight')
    plt.show()
