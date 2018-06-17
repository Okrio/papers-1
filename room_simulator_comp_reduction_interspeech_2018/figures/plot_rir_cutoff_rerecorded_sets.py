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
data.append((x_data, 100 - np.array([31.88, 24.19, 21.82, 21.87]),
             "Relatively Clean"))

data.append((x_data, 100 - np.array([51.12, 40.00, 35.83, 35.88]),
             "Music"))
data.append((x_data, 100 - np.array([58.30, 48.36, 46.22, 46.03]),
             "Interfering Speakers"))


#data.append((x_data, 100 - np.array([88, 40.643, 43.247, 42.604]), "Simulated Noise Set 1"))
#data.append((x_data, 100 - np.array([88, 40.643, 43.247, 42.604]), "Simulated Noise Set 2"))


data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()
plt.axis([5, 25, 0, 100])


#plt.title("\textit{Rerecorded Noisy Test Set \n (Mobile Voice Search Test Set)}")
plt.title("Rerecorded Mobile \n Voice Search Test Set")
#plt.ylabel('\textit{Accuracy (100 - WER \%)}')
plt.xlabel('Room Impulse Response Cutoff Threshold (dB).')

file_name = "./rir_cutoff_rerecorded_sets.eps"
fig.set_size_inches(10.0, 6.0)
fig.savefig(file_name,  bbox_inches='tight')


subprocess.check_call(shlex.split("evince {0}".format(file_name)))


