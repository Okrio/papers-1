#!/usr/bin/python

import numpy as np

def CalculateRelImprovement(data):
  relative = data / (1.0 - data)
  print (relative[0] / relative)

data= np.array([79.27, 10.11, 6.23, 6.03]) / 100

CalculateRelImprovement(data)

data= np.array([80.01, 13.30, 9.69, 8.05]) / 100

CalculateRelImprovement(data)


#baseline = 80.01 / 100
#data= [13.30, 9.69, 8.05] / 100
