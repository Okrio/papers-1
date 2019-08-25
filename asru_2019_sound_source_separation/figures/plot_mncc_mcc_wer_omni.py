#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

import pylab as plot
params = {'legend.fontsize': 10,
          'legend.handlelength': 2}
plot.rcParams.update(params)

snr_db = np.array([0.0, 5.0, 10.0, 15.0, 20.0, float("inf")])

# Omni drectional noise
mncc_mcc = np.array([23.0, 58.0, 80.0, 85.0, 88.0, 90.0])
mcc      = np.array([23.0, 58.0, 80.0, 85.0, 88.0, 90.0])  # green
mncc     = np.array([10.0, 27.0, 62.0, 82.0, 86.0, 90.0])  # red
pdcw     = np.array([17.0, 42.0, 72.0, 82.5, 86.0, 90.0])  # pdcw
single   = np.array([ 2.0, 15.0, 45.0, 73.0, 83.0, 90.0])  # single

data = []
data.append((snr_db, mncc_mcc))
data.append((snr_db, mcc))
data.append((snr_db, mncc))
data.append((snr_db, pdcw))
data.append((snr_db, single))

#data_list_plot.PlotDiscreteData(data)
data_list_plot.PlotSnrdbAccData(data)
plt.axis([0, 25.0, 0.0, 100.0])
fig = plt.gcf()
fig.gca().get_legend().remove()

plt.title(r'RM1 (Omni-Directional Noise)')
plt.xlabel(r'SNR (dB)')
#plt.ylabel('Accuracy (100 - WER \%)')
#plt.title(r"\textit{RM1 ($RT_{60}$ = 200 {\it ms})")
#plt.xlabel(r'\textit{SIR (dB)}')
#plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.tight_layout()
#
file_name = './plot_mncc_mcc_wer_omni.eps'
fig.savefig(file_name)
#
