#!/usr/bin/python
"""TODO(chanwcom): DO NOT SUBMIT without one-line documentation for process.

TODO(chanwcom): DO NOT SUBMIT without a detailed description of process.
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import matplotlib.pyplot as plt
import numpy as np
import re
import sys

from plot_util import data_list_plot

def PlotRirHistogram(input_text_file, output_eps_file):
  x = np.array([])
  with open(input_text_file) as file:
    for line in file:
      match = re.search("\|\s+(\d+)\s+\|", line.rstrip())

      if match:
        data = float(match.group(1))
        # To handle zero length rir in the noise RIRs when SNR is inf. dB.
        if data >  0:
          x = np.append(x, data)

  # Converts samples into seconds.
  print (np.mean(x))
  x = x / 16000.0

  bin = np.arange(0, 0.5, 0.02)

  hist, bin_edges = np.histogram(x, bin)

  bin_centers = np.zeros(len(bin_edges) - 1)
  for i in range(0, len(bin_centers)):
    bin_centers[i] = (bin_edges[i] + bin_edges[i + 1]) / 2.0

  hist = np.concatenate(([0.0], hist, [0.0]))
  bin_centers = np.concatenate(([0.0], bin_centers, [0.5]))

  data = []
  data.append((bin_centers, hist, ""))

  plt.gcf().clear()
  data_list_plot.PlotSolidContinuousData(data)
  plt.title('The Distribution of \n Room Impulse Response (RIR) Lengths')
  plt.xlabel(r'Length (s)')
  plt.ylabel('Probability Density Function (PDF)')
  #plt.show()

  fig = plt.gcf()
  fig.savefig(output_eps_file)

if __name__ == "__main__":
  PlotRirHistogram("target_length.txt", "target_length.eps")
  PlotRirHistogram("noise_length.txt", "noise_length.eps")
