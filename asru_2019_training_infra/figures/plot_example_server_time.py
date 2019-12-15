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
data.append((dist, [163.7, 82.4, 62.0, 58.8, 53.7]))
plt.plot([0.0, 5.2], [65.6, 65.6], '--',  linewidth=2)

data_list_plot.PlotDiscreteData(data)
fig = plt.gcf()
plt.axis([0.8, 5.2, 0.0, 180.0])

fig = plt.gcf()
fig.set_size_inches(5,3)


ax = plt.gca()
ax.get_legend().remove()

plt.ylabel(r'\textit{Elapsed Time per Epoch (in Hr)}')
plt.xlabel(r"\textit{Number of CPUs in the Example Server per GPU}")
plt.tight_layout()

file_name = "plot_example_server_time.eps"
fig.savefig(file_name)

#subprocess.check_call(shlex.split("evince {0}".format(file_name)))

