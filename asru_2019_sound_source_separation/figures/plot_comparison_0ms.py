#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

import pylab as plot
params = {'legend.fontsize': 13,
          'legend.handlelength': 2}
plot.rcParams.update(params)

#snr_db = np.array([0.0, 5.0, 10.0, 15.0, 20.0, 25])# float("inf")])
snr_db = np.array([0.0, 5.0, 10.0, 15.0, 20.0, float("inf")])

# 200 ms reverberation time (interfering speaker)
mncc_mcc    = np.array([85.0, 87.0, 88.0, 89.0, 89.5, 90.0])
mcc         = np.array([85.0, 87.0, 88.0, 89.0, 89.5, 90.0])  # green
auto_itd_th = np.array([82.0, 84.0, 85.5, 86.5, 88.0, 90.0])  # red
pdcw        = np.array([85.0, 87.0, 88.0, 89.0, 89.5, 90.0])  # pdcw
ds          = np.array([ 4.0, 42.0, 65.0, 80.0, 88.0, 90.0])  # single
single      = np.array([ 2.0, 32.0, 58.0, 75.0, 84.0, 90.0])  # single

data = []
data.append((snr_db, mncc_mcc, 'MNCC-MNCV'))
data.append((snr_db, mcc, 'MNCC-MNCV (w/o CW)'))
data.append((snr_db, auto_itd_th, 'Auto-ITD-Th'))
data.append((snr_db, pdcw, 'ZCAE'))
data.append((snr_db, ds, 'Delay and Sum'))
data.append((snr_db, single, 'Single Mic.'))

#data_list_plot.PlotDiscreteData(data)
data_list_plot.PlotSnrdbAccData(data)
plt.axis([0, 25.0, 0.0, 100.0])
fig = plt.gcf()

plt.title(r'RM1 (RT60 = 0 ms)')
plt.xlabel(r'SIR (dB)')
#plt.ylabel('Accuracy (100 - WER \%)')
#plt.title(r"\textit{RM1 ($RT_{60}$ = 200 {\it ms})")
#plt.xlabel(r'\textit{SIR (dB)}')
#plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.tight_layout()
#
file_name = './plot_comparison_0ms.eps'
fig.savefig(file_name)
#
