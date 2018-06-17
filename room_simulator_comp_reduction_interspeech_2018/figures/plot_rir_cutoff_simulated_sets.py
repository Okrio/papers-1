#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

#plt.rc('text', usetex=True)

x_data = np.array([5.0, 10.0, 20.0, float("inf")])


# The data at 41.000 is problematic.
data = []
data.append((x_data, 100 - np.array([11.20, 10.75, 11.43, 11.95]),
             "Original"))
           #  "Original Set"))
data.append((x_data, 100 - np.array([14.99, 13.59, 13.96, 14.88]),
             "Simulated Noisy Set A"))

data.append((x_data, 100 - np.array([28.27, 21.37, 19.58, 22.29]),
             "Simulated Noisy Set B"))



data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()
plt.axis([5, 25, 0, 100])


#plt.title("\textit{Rerecorded Noisy Test Set \n (Mobile Voice Search Test Set)}")
plt.title("Simulated Noisy Mobile \n Voice Search Test Set")
#plt.ylabel('\textit{Accuracy (100 - WER \%)}')
plt.xlabel('Room Impulse Response Cutoff Threshold (dB).')

file_name = "./rir_cutoff_simulated_sets.eps"
fig.set_size_inches(10.0, 6.0)
fig.savefig(file_name, bbox_inches='tight')



subprocess.check_call(shlex.split("evince {0}".format(file_name)))


