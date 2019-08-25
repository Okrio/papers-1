#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

#snr_db = np.array([0.0, 5.0, 10.0, 15.0, 20.0, 25])# float("inf")])
snr_db = np.array([0.0, 5.0, 10.0, 15.0, 20.0, float("inf")])

# 200 ms reverberation time (interfering speaker)
mncc_mcc    = np.array([38.0, 50.0, 53.0, 62.0, 72.0, 78.0])
mcc         = np.array([32.0, 43.0, 48.0, 59.0, 70.0, 78.0])  # green
auto_itd_th = np.array([30.0, 42.0, 55.0, 64.0, 73.0, 78.0])  # red
zcae        = np.array([12.0, 27.0, 47.0, 60.0, 70.0, 78.0])  # zcae
ds          = np.array([ 4.0, 18.0, 35.0, 55.0, 68.0, 78.0])  # single
single      = np.array([ 2.0, 15.0, 32.0, 53.0, 66.0, 78.0])  # single

data = []
data.append((snr_db, mncc_mcc))
data.append((snr_db, mcc))
data.append((snr_db, auto_itd_th))
data.append((snr_db, zcae))
data.append((snr_db, ds))
data.append((snr_db, single))


#data_list_plot.PlotDiscreteData(data)
data_list_plot.PlotSnrdbAccData(data)
plt.axis([0, 25.0, 0.0, 100.0])
fig = plt.gcf()


fig.gca().get_legend().remove()

plt.title(r'RM1 (RT60 = 200 ms)')
plt.xlabel(r'SIR (dB)')
#plt.ylabel('Accuracy (100 - WER \%)')
#plt.title(r"\textit{RM1 ($RT_{60}$ = 200 {\it ms})")
#plt.xlabel(r'\textit{SIR (dB)}')
#plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.tight_layout()
#
file_name = './plot_comparison_200ms.eps'
fig.savefig(file_name)
#
