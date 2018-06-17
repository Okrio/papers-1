#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

reverb_time = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
hist_mtr3 = np.array([4.0, 6.0, 8.0, 10.0, 13.0, 17.0, 17.0, 13.0, 8.0, 4.0, 0.0])
hist_mtr3 = hist_mtr3 / np.sum(hist_mtr3) / 0.1


hist_real = np.array([0, 0, 0, 0, 2, 10, 11, 16, 13, 17, 19, 31, 21, 23, 16, 17, 4, 4, 3, 0])
hist_real = hist_real / float(np.sum(hist_real)) / 0.05
reverb_real = np.linspace(0.025, 0.975, len(hist_real)) 


data = []
data.append((reverb_time,
             hist_mtr3,
             "Room Simulator"))
data.append((reverb_real,
             hist_real,
             "Real Usage"))

plt.axis([0.0, 1.0, 0.0, 3.5])

data_list_plot.PlotDiscreteData(data)
fig = plt.gcf()
fig.savefig("./reverb_time_distribution.eps")


