#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt


cutoff_db = np.array([5.0, 10.0, 15.0, 20.0, float("inf")])
time1 = np.array([0.97, 1.16, 1.21, 1.43, 1.94]) * 10
time2 = np.array([3.24, 3.35, 3.41, 3.28, 3.36]) * 10




data = []
data.append((cutoff_db,
             time1,
             "OLA FFT Filtering"))

data.append((cutoff_db,
             time2,
             "Full FFT Filtering"))

print (data)

#plt.axis([0.0, 1.0, 0.0, 3.5])

data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()

plt.xlabel('Room Impulse Response Cutoff Threshold (dB)')
plt.ylabel('Calculation Time (ms)')
plt.axis([5, 25, 0, 50])


#fig.set_size_inches(10.0, 6.0)
fig.savefig("./rir_cutoff_time.eps",  bbox_inches='tight')
#fig.savefig("./rir_cutoff_time.eps", dpi=100)




