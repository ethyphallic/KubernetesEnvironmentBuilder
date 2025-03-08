import random
import matplotlib.pyplot as plt

fig = plt.figure()
ax = fig.add_subplot(111)

i = 0
x, y = [], []
maxlen = 100

while True:
    x.append(i)
    y.append(random.randint(0,10))

    #if len(x) > maxlen:
    #    del x[0]
    #    del y[0]

    #ax.clear()
    #ax.set_xlim(left=max(0, i - 50), right=i + 50)
    ax.plot(x, y, color='b')
    fig.canvas.draw()
    fig.canvas.flush_events()
    plt.pause(1)

    i += 1