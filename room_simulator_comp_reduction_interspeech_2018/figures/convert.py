#!/usr/bin/python

import numpy as np

sigma = np.array([0.0, 0.4, 1.6, np.inf])
y = 1.0 - np.exp(-sigma ** 2 / 2.0)
print y

