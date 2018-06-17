#!/usr/bin/python
# Draws the von Mises Distribution pdf.
#
# Refer to the von Mises distribution in
# https://en.wikipedia.org/wiki/Von_Mises_distribution

import numpy as np

from plot_util import data_list_plot
from scipy.stats import vonmises
import matplotlib.pyplot as plt

def PlotPDF():
  mu = 0.0
  kappa_list = [0.0, 0.5, 1.0, 2.0, 4.0, 8.0]

  data = []
  for kappa in kappa_list:
    x = np.linspace(-np.pi, np.pi, 100)
    if kappa == 0.0:
      y = 1 / (2.0 * np.pi) * np.ones(len(x))
    else:
      y = vonmises.pdf(x, kappa)

    data.append(([x, y, "$\kappa = {0}$".format(kappa)]))

  data_list_plot.PlotContinuousData(data)
  plt.axis([-np.pi, np.pi, 0.0, 1.2])
  plt.xlabel('$x$')
  plt.ylabel('Probability Density Function (PDF)')
  fig = plt.gcf()
  fig.savefig("./von_mises_pdf.eps")


if __name__ == "__main__":
  PlotPDF()

