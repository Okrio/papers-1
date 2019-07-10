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


angle = np.array([15, 20, 30, 45, 60, 70])

# Omni drectional noise
mncc_mcc    = np.array([40.0, 49.0, 62.0, 63.0, 62.0, 65.0])
mcc         = np.array([37.0, 40.0, 59.0, 57.5, 57.0, 59.0])  # green
auto_itd_th = np.array([41.0, 44.0, 50.0, 42.5, 42.0, 46.0])  # zcae
zcae        = np.array([4.0, 10.0, 22.0, 41.0, 41.5, 43.0])  # zcae
single      = np.array([ 3.0, 2.0, 1.0, 2.0, 2.0, 2.0])  # single

data = []
data.append((angle, mncc_mcc, 'MNCC-MNCV'))
data.append((angle, mcc, 'MNCC-MNCV (w/o CW)'))
data.append((angle, auto_itd_th, 'Auto-ITD-Th'))
data.append((angle, zcae, 'ZCAE'))
data.append((angle, single, 'Single Mic.'))

#data_list_plot.PlotDiscreteData(data)
data_list_plot.PlotDiscreteData(data)
plt.axis([15.0, 70.0, 0.0, 100.0])
fig = plt.gcf()


#ax = plt.subplot(111)
#ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.20))

plt.title(r'RM1 ($RT_{60} = 100 ms$)')
plt.xlabel(r'Interfering Source Angle $\theta_t$')
plt.ylabel('Accuracy (100 - WER %)')
#plt.title(r"\textit{RM1 ($RT_{60}$ = 200 {\it ms})")
#plt.xlabel(r'\textit{SIR (dB)}')
#plt.ylabel(r'\textit{Accuracy (100 - WER \%)}')
plt.tight_layout()
#
file_name = './plot_comparison_angle.eps'
fig.savefig(file_name)
#
