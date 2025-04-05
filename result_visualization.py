import matplotlib.pyplot as plt
import numpy as np

if __name__ == '__main__':
    #prefix = "hwkds" #CPU stress
    prefix = "dgtze" #Network stress

    # Sample data
    x0 = np.loadtxt(f"result/{prefix}-latency.csv", delimiter=',')
    x1 = np.loadtxt(f"result/{prefix}-energy.csv", delimiter=',')
    x2 = np.loadtxt(f"result/{prefix}-accuracy.csv", delimiter=',')

    # Create the plot
    plt.plot( 1*((x0[45:]/2.5) -1), label="latency" , linestyle="--")
    plt.plot( 1*((x1[45:]/ 60) -1), label="energy"  , linestyle="-.")
    plt.plot(10*((x2[45:]/0.75)-1), label="accuracy", linestyle=":")

    # Add labels and title
    plt.axvline(x=20, color='r')
    plt.axvline(x=50, color='r')

    plt.xlabel("time in seconds")
    plt.ylabel("Ratio of SLO violation")
    #plt.title("Scenario: CPU stress")
    plt.title("Scenario: Network Latency")

    plt.legend()
    # Display the plot
    plt.savefig(f'result/plot-{prefix}.pdf', bbox_inches='tight')
    plt.show()
