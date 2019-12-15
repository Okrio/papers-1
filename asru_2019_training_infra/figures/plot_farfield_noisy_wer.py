#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from util.plot_util import data_list_plot
import matplotlib.pyplot as plt

plt.rc('text', usetex=True)

data = []
x_snr = np.array([0.0, 5.0, 10.0, 15.0, 20.0])

# The data at 41.000 is problematic.
data.append((x_snr, 100 - np.array([3.07, 1.54, 0.92, 1.84, 1.53]),
    "NBF + VTLP + AS"))
data.append((x_snr, 100 - np.array([22.46, 4.29, 1.53, 1.53, 1.53]),
    "VTLP + AS"))
data.append((x_snr, 100 - np.array([84.91, 31.37, 5.21, 2.76, 1.84]),
    "baseline"))

data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()

plt.title(r"\textit{Commmand Set (Babble Noise)}")
plt.tight_layout()
plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.xlabel(r'\textit{SNR (dB)}')
plt.axis([-1.0, 21.0, 0.0, 100.0])

file_name = "plot_farfield_wer_babble.eps"
fig.savefig(file_name)

#subprocess.check_call(shlex.split("evince {0}".format(file_name)))


# TV_direct
plt.figure()

data = []
x_snr = np.array([0.0, 5.0, 10.0, 15.0, 20.0])

data.append((x_snr, 100 - np.array([3.99, 2.15, 1.53, 1.86, 0.92]),
    "NBF + VTLP + AS"))
data.append((x_snr, 100 - np.array([26.23, 10.15, 1.53, 1.53, 0.92]),
    "VTLP + AS"))
data.append((x_snr, 100 - np.array([68.55, 51.26, 16.77, 6.44, 2.15]),
    "baseline"))

data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()

plt.title(r"\textit{Commmand Set (TV Noise)}")
plt.tight_layout()
plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.xlabel(r'\textit{SNR (dB)}')
plt.axis([-1.0, 21.0, 0.0, 100.0])

file_name = "plot_farfield_wer_tv.eps"
fig.savefig(file_name)


# Music
plt.figure()
data = []
x_snr = np.array([0.0, 5.0, 10.0, 15.0, 20.0])

# The data at 41.000 is problematic.
data.append((x_snr, 100 - np.array([48.46, 3.68, 0.92, 1.53, 0.92]),
    "NBF + VTLP + AS"))
data.append((x_snr, 100 - np.array([42.90, 9.54, 2.76, 1.53, 1.84]),
    "VTLP + AS"))
data.append((x_snr, 100 - np.array([93.42, 44.06, 13.54, 3.99, 3.68]),
    "baseline"))

data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()

plt.title(r"\textit{Commmand Set (Music Noise)}")
plt.tight_layout()
plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.xlabel(r'\textit{SNR (dB)}')
plt.axis([-1.0, 21.0, 0.0, 100.0])

file_name = "plot_farfield_wer_music.eps"
fig.savefig(file_name)
