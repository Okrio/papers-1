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
mncc_mcc = np.array([38.0, 50.0, 53.0, 62.0, 72.0, 78.0])
mcc      = np.array([27.0, 41.0, 52.0, 61.0, 71.5, 78.0])  # green
mncc     = np.array([38.0, 41.0, 42.0, 60.0, 71.0, 78.0])  # red
pdcw     = np.array([12.0, 29.0, 47.0, 60.0, 70.0, 78.0])  # pdcw
single   = np.array([ 2.0, 15.0, 32.0, 53.0, 66.0, 78.0])  # single

data = []
data.append((snr_db, mncc_mcc, 'MNCC-MNCV'))
data.append((snr_db, mcc, 'MNCC'))
data.append((snr_db, mncc, 'MNCV'))
data.append((snr_db, pdcw, 'PDCW'))
data.append((snr_db, single, "Single Mic"))

#data_list_plot.PlotDiscreteData(data)
data_list_plot.PlotSnrdbAccData(data)
plt.axis([0, 25.0, 0.0, 100.0])
fig = plt.gcf()

plt.title(r'RM1 (RT60 = 200 ms)')
plt.xlabel(r'SIR (dB)')
#plt.ylabel('Accuracy (100 - WER \%)')
#plt.title(r"\textit{RM1 ($RT_{60}$ = 200 {\it ms})")
#plt.xlabel(r'\textit{SIR (dB)}')
#plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.tight_layout()
#
file_name = './plot_mncc_mcc_wer_200ms.eps'
fig.savefig(file_name)
#






