#!/usr/bin/python

import numpy as np

Nx = 116991.0
Nh = 3893.0
I = 2.55
J = 2

print ("FIR FFT filter")
N = 2 ** 17
c_fir_fft = I * J * (6 * N * np.log2(N) + 2 * N)
print (c_fir_fft)


print ("---------------12---------------")
N = 2 ** 12

c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))
print (np.ceil(Nx / (N - Nh + 1)))
print (c_ola / 1.0e6)

print ("---------------13---------------")
N = 2 ** 13

c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))
print (np.ceil(Nx / (N - Nh + 1)))
print (c_ola / 1.0e6)

print ("---------------14---------------")
N = 2 ** 14

c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))

print (np.ceil(Nx / (N - Nh + 1)))
print (c_ola / 1.0e6)

print ("----------------15--------------")

N = 2 ** 15

c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))
print (np.ceil(Nx / (N - Nh + 1)))
print (c_ola / 1.0e6)

print ("----------------16--------------")
N = 2 ** 16

c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))
print (c_ola / 1.0e6)

print ("----------------17-------------")
N = 2 ** 17
c_ola = I * J * (np.ceil(Nx / (N - Nh + 1)) * (4 * N * np.log2(N) + 2 * N) + 2 * N * np.log2(N))
print (Nx / (N - Nh + 1))
print (np.ceil(Nx / (N - Nh + 1)))
print (c_ola / 1.0e6)

