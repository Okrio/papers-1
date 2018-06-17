#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt


def _GetMinFftSize(signal_length):
  return int(2 ** np.ceil(np.log2(signal_length)))

N_x = 116991.0
B_array = np.arange(100, N_x + 1000, 100.0) # block_size
M = 3893.0


Mult_array = np.zeros(np.shape(B_array))

index = 0
N = float(_GetMinFftSize(N_x + M - 1))
total = 6.0 * N * np.log2(N) + 2.0 * N
for B in B_array:
  N = float(_GetMinFftSize(B + M - 1))
 # N = B + M - 1

  mult =  np.ceil(float(N_x) / float(B)) * (4.0 * N * np.log2(N) + 2.0 * N)  + (2.0 * N * np.log2(N))

  Mult_array[index] = mult
  index = index + 1


print (B_array[np.argmin(Mult_array)])
print (np.min(Mult_array))
print "=============="

Mult_array2 = np.zeros(np.shape(B_array))

index = 0
N = float(_GetMinFftSize(N_x + M - 1))
total = 6.0 * N * np.log2(N) + 2.0 * N
for B in B_array:
 # N = float(_GetMinFftSize(B + M - 1))
  N = B + M - 1

  mult =  np.ceil(float(N_x) / float(B)) * (4.0 * N * np.log2(N) + 2.0 * N)  + (2.0 * N * np.log2(N))

  Mult_array2[index] = mult
  index = index + 1


print (min(Mult_array) / 1e7)

Mult_array3 = total * np.ones(np.shape(B_array))

plt.plot(B_array, Mult_array)
plt.plot(B_array, Mult_array2)
plt.plot(B_array, Mult_array3)
plt.axis([0, N_x, 0, 1.5 * total])
plt.show()
