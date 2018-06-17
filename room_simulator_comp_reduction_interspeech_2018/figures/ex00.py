#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt

x = np.arange(0, 1000, 10)
y = x / 100 *  np.log2(x / 100)

plt.plot(x, y)
plt.show()
