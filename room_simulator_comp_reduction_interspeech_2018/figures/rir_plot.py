#!/usr/bin/python

import matplotlib
import matplotlib.pyplot as plt
import re
import numpy as np

from google3.experimental.users.chanwcom.my_pythonlib.plot_util import data_list_plot

plt.rc('text', usetex=True)
font = {"family": "sans-serif", "size": 17}
plt.rc("font", **font)


def ReturnFirstRIR():
#  file_name = 'rir_data.txt'
  file_name = 'samples_data.txt'
  samples = []
  with open(file_name) as fp:
    for line in fp:

      match = re.match("\s*sample:\s*\[(.*)\]\s*", line)

      if match:
        data =  match.group(1)
        data = data.split(",")

        rir_array = np.array([])
        for elem in data:
          rir_array = np.append(rir_array, float(elem))

        return rir_array


def DecibelToPowerRatio(decibel):
  if decibel == -np.inf:
    return 0.0

  if decibel == np.inf:
    return np.inf

  return 10.0 ** (decibel / 10.0)


def CutRirTailBelowThreshold(rir_array, threshold_db):
  """ Threshold dB means that dB below the maximum"""

  if threshold_db != np.inf:
    power_signal = rir_array ** 2
    max_power = np.max(power_signal)
    threshold_level =  max_power * DecibelToPowerRatio(-threshold_db)

    for i in np.arange(len(rir_array) - 1, -1, -1):
      if power_signal[i] >= threshold_level:
        break

    cut_off_rir_array = rir_array[0 : i + 1]

    if i + 1 <= len(rir_array) - 1:
      ratio = 10.0 * np.log10(max_power / np.max(rir_array[i + 1 : ] ** 2))
    else:
      ratio = np.inf


    print (ratio)

  return cut_off_rir_array

def main():
  rir_array = ReturnFirstRIR()
  sampling_rate_hz = 16000.0
  time = np.linspace(0.0, len(rir_array) / sampling_rate_hz, len(rir_array))

  #plt.subplot(4, 1, 1)

  data = []
  data.append((time, rir_array, ""))

  kwargs = {"linewidth": 2}
  data_list_plot.PlotContinuousData(data, kwargs)
  plt.xlabel('Time (s)')

  fig = plt.gcf()
  fig.set_size_inches(10.0, 3.0)
  fig.savefig(r"rir_no_cutoff.eps", bbox_inches='tight')






  cut_off_rir_array = CutRirTailBelowThreshold(rir_array, 20)

  zero_padded = np.zeros(np.shape(rir_array))
  zero_padded[0:len(cut_off_rir_array)] = cut_off_rir_array

  data = []
  data.append((time, zero_padded, ""))

  kwargs = {"linewidth": 2}
  plt.gcf().clear()
  data_list_plot.PlotContinuousData(data, kwargs)
  plt.xlabel('Time (s)')



  x_cutoff =  len(cut_off_rir_array) / 16000.0
  x = np.linspace(x_cutoff, x_cutoff, 10)
  y = np.linspace(-0.05, 0.3, 10)
  plt.plot(x, y, '--', linewidth=2, color='r')



  fig = plt.gcf()
  fig.set_size_inches(10.0, 3.0)
  fig.savefig("rir_20db_cutoff.eps", bbox_inches='tight')




  cut_off_rir_array = CutRirTailBelowThreshold(rir_array, 10)

  zero_padded = np.zeros(np.shape(rir_array))
  zero_padded[0:len(cut_off_rir_array)] = cut_off_rir_array

  data = []
  data.append((time, zero_padded, ""))

  kwargs = {"linewidth": 2}
  plt.gcf().clear()
  data_list_plot.PlotContinuousData(data, kwargs)
  plt.xlabel('Time (s)')

  x_cutoff =  len(cut_off_rir_array) / 16000.0
  x = np.linspace(x_cutoff, x_cutoff, 10)
  y = np.linspace(-0.05, 0.3, 10)
  plt.plot(x, y, '--', linewidth=2, color='r')

  fig = plt.gcf()
  fig.set_size_inches(10.0, 3.0)
  fig.savefig("rir_10db_cutoff.eps", bbox_inches='tight')







  cut_off_rir_array = CutRirTailBelowThreshold(rir_array, 5)

  zero_padded = np.zeros(np.shape(rir_array))
  zero_padded[0:len(cut_off_rir_array)] = cut_off_rir_array

  data = []
  data.append((time, zero_padded, ""))

  kwargs = {"linewidth": 2}
  plt.gcf().clear()
  data_list_plot.PlotContinuousData(data, kwargs)
  plt.xlabel('Time (s)')

  x_cutoff =  len(cut_off_rir_array) / 16000.0
  x = np.linspace(x_cutoff, x_cutoff, 10)
  y = np.linspace(-0.05, 0.3, 10)
  plt.plot(x, y, '--', linewidth=2, color='r')

  fig = plt.gcf()
  fig.set_size_inches(10.0, 3.0)
  fig.savefig("rir_5db_cutoff.eps", bbox_inches='tight')



if __name__ == "__main__":
  main()


