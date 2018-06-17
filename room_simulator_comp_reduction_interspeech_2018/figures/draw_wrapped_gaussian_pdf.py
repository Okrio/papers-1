#!/usr/bin/python
# Draws the von Mises Distribution pdf.
#
# Refer to the von Mises distribution in
# https://en.wikipedia.org/wiki/Von_Mises_distribution

import numpy as np
import mpmath

from plot_util import data_list_plot
from scipy.stats import vonmises
import matplotlib.pyplot as plt

def PlotPDF():
  mu = 0.0
#  sigma_list = np.sqrt([1.0/8.0, 1.0/4.0, 1.0/2.0, 1.0, 2.0, 1000.0])
  sigma_list = np.sqrt([1.0/8.0, 1.0/4.0, 1.0/2.0, 1.0, 2.0])


  data = []
  x = np.linspace(-np.pi, np.pi, 100)
  for sigma in sigma_list:
    tau = 1.0j * sigma ** 2 / (2.0 * np.pi)
    q = np.exp(1.0j * np.pi * tau)

    mapping = np.frompyfunc(lambda *a: float(mpmath.jtheta(*a)), 3, 1)
    y = 1 / (2.0 * np.pi) * mapping(3, x / 2.0, q)
    data.append(([x, y, "$\sigma = {0}$".format(sigma * sigma)]))

  # TODO(chanwcom) Process the infinity standard deviation case.
  y = 1 / (2.0 * np.pi) * np.ones(np.shape(x))
  data.append(([x, y, "$\sigma = \infty$"]))

  data_list_plot.PlotContinuousData(data)
  plt.axis([-np.pi, np.pi, 0.0, 1.2])
  plt.xlabel('$x$')
  plt.ylabel('Probability Density Function (PDF)')
  fig = plt.gcf()
  fig.savefig("./wrapped_gaussian_pdf.eps")


if __name__ == "__main__":
  PlotPDF()

