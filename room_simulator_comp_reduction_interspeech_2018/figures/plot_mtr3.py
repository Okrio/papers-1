#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

plt.rc('text', usetex=True)

sigma = np.array([0.0, 0.1, 0.4, 1.6, np.inf])

# The phase distortion amount.
x_data = np.sqrt(1.0 - np.exp(-sigma ** 2 / 2.0))


# The data at 41.000 is problematic.
data = []
data.append((x_data, 100 - np.array([39.728, 38.888, 40.643, 43.247, 42.604]), "$\sigma_m = 0.0$"))
data.append((x_data, 100 - np.array([40.049, 37.850, 39.744, 41.819, 42.728]), "$\sigma_m = 1.0$"))
data.append((x_data, 100 - np.array([40.164, 40.057, 40.139, 42.400, 42.831]), "$\sigma_m = 2.0$"))

# 41.904 is a false data. Rerun?
data.append((x_data, 100 - np.array([41.904, 41.344, 41.780, 43.597, 43.470]), "$\sigma_m = 4.0$"))

data_list_plot.PlotDiscreteData(data)
fig = plt.gcf()
plt.axis([0, 1.0, 50.0, 70.0])


plt.title(r"\textit{Rerecorded noisy test set (13k mobile set)}")
plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.xlabel(r'\textit{Circular standard deviation $s$}')
fig.savefig("./test.eps")

subprocess.check_call(shlex.split("evince test.eps"))

