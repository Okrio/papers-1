#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

x_snr = np.array([0, 5, 10, 15, 20])

data = []
data.append((x_snr,
             100 - np.array([22.5, 19.7, 18.0, 16.9, 16.3]),
             "PDCW"))
data.append((x_snr,
             100 - np.array([42.5, 32.7, 24.0, 21.9, 16.3]),
             "OS-PDCW"))
data.append((x_snr,
             100 - np.array([79.5, 59.9, 40.1, 25.8, 19.1]),
             "Baseline"))

data_list_plot.PlotSnrdbAccData(data)
plt.xlabel('SNR (dB)')
plt.ylabel('Acc (100 - WER)')
fig = plt.gcf()
fig.savefig("./symmetric_noreverb.eps")
subprocess.check_call('evince symmetric_noreverb.eps', shell=True)

plt.figure()

data = []
data.append((x_snr,
             100 - np.array([72.0, 55.0, 42.0, 35.0, 31.0]),
             "PDCW"))
data.append((x_snr,
             100 - np.array([62.0, 49.0, 38.0, 32.0, 30.0]),
             "OS-PDCW"))
data.append((x_snr,
             100 - np.array([82.0, 64.0, 49.0, 39.0, 32.0]),
             "Baseline"))

data_list_plot.PlotSnrdbAccData(data)
plt.xlabel('SNR (dB)')
plt.ylabel('Acc (100 - WER)')
fig = plt.gcf()
fig.savefig("./symmetric_reverb.eps")
subprocess.check_call('evince symmetric_reverb.eps', shell=True)

plt.figure()
data = []
data.append((x_snr,
             100 - np.array([97.0, 79.0, 62.0, 49.0, 37.0]),
             "PDCW"))
data.append((x_snr,
             100 - np.array([72.0, 54.0, 44.0, 38.0, 33.0]),
             "OS-PDCW"))
data.append((x_snr,
             100 - np.array([83.0, 66.0, 51.0, 42.0, 33.0]),
             "Baseline"))

data_list_plot.PlotSnrdbAccData(data)
plt.xlabel('SNR (dB)')
plt.ylabel('Acc (100 - WER)')
fig = plt.gcf()
fig.savefig("./asymmetric_reverb.eps")
subprocess.check_call('evince asymmetric_reverb.eps', shell=True)

