#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from util.plot_util import data_list_plot
import matplotlib.pyplot as plt

plt.rc('text', usetex=True)

dist = np.array([1.0, 2.0, 3.0, 4.0, 5.0])

data = []

# The data at 41.000 is problematic.
data.append((dist, [35.0, 85.7, 91.8, 92.8, 96.6]))
plt.plot([0.0, 5.2], [94.8, 94.8], '--',  linewidth=2)

data_list_plot.PlotDiscreteData(data)
fig = plt.gcf()
plt.axis([0.8, 5.2, 0.0, 100.0])

fig = plt.gcf()
fig.set_size_inches(5,3)

ax = plt.gca()
ax.get_legend().remove()

plt.ylabel(r'\textit{Tensorflow Session Time (\%)}')
plt.xlabel(r"\textit{Number of CPUs in the Example Server per GPU}")
plt.tight_layout()

file_name = "plot_gpu_time_percentage.eps"
fig.savefig(file_name)

#subprocess.check_call(shlex.split("evince {0}".format(file_name)))

