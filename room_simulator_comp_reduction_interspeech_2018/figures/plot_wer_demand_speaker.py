#!/usr/bin/python

import shlex
import subprocess
import numpy as np
from plot_util import data_list_plot
import matplotlib.pyplot as plt

x_snr = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])

data = []
data.append((x_snr,
             100 - np.array([14.5945949554,  20.5100955963,  30.3931980133,  27.3738231659,  30.1573429108,  31.6046962738,  36.9088821411,  39.9317398071,  37.4674758911,  33.8645401001]),
                 
             "RMS-PDCW"))
data.append((x_snr,
             100 - np.array([12.1081085205,  23.2731132507,  31.4558982849,  31.9931564331,  38.0244750977,  38.0626220703,  44.40599823,  47.2696228027,  46.9210739136,  43.6254997253]),
             "PDCW"))
data.append((x_snr,
             100 - np.array([
                 11.6756753922,  17.2157287598,  26.0361309052,  22.412317276,  24.5629367828,  26.2230911255,  28.8350639343,  31.3993167877,  31.6565475464,  25.1992034912, ]),
             "MTR"))

data.append((x_snr,
             100 - np.array([
                  20.4324321747,  34.2189178467,  50.2656745911,  52.2668952942,  58.0419578552,  60.6653633118,  69.0888137817,  72.3549499512,  70.0780563354,  73.8047790527 ]),
             "Without MTR"))

data_list_plot.PlotSnrdbAccData(data)
fig = plt.gcf()
plt.axis([0.0, 0.9, 0.0, 100])
plt.title("Mobile search task \n 0 dB SNR DEMAND noise")
plt.ylabel('Accuracy (100 - WER%)')
plt.xlabel('Reverberation Time ($T_{60}$) in Seconds')
fig.savefig("./demand_0db.eps")

subprocess.check_call(shlex.split("evince demand_0db.eps"))
