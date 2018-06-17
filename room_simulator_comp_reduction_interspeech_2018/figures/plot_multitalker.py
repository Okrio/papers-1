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
data.append((x_data, 100 - np.array([52.568, 51.436, 55.331, 57.861, 52.955]), "$\sigma_m = 0.0$"))
data.append((x_data, 100 - np.array([51.343, 48.775, 49.628, 55.675, 56.391]), "$\sigma_m = 1.0$"))
data.append((x_data, 100 - np.array([49.571, 51.905, 51.509, 54.468, 52.893]), "$\sigma_m = 2.0$"))

data_list_plot.PlotDiscreteData(data)
fig = plt.gcf()
plt.axis([0, 1.0, 40.0, 60.0])

plt.title(r"\textit{Rerecorded multitalker test set (13k mobile set)}")
plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.xlabel(r'\textit{Circular standard deviation $s$}')

file_name = "mtr_multitalker.eps"
fig.savefig(file_name)

subprocess.check_call(shlex.split("evince {0}".format(file_name)))

