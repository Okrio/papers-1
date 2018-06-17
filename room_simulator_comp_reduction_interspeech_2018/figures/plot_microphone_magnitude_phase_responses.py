#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
import numpy.fft
import os
import sys
import scipy.io.wavfile
import scipy.signal

from plot_util import data_list_plot


def ObtainSpeechFrame(file_name):
  assert(os.path.exists(file_name))

  (sampling_rate_hz, audio_data) = scipy.io.wavfile.read(file_name)
  print sampling_rate_hz

  length_in_sec = 0.10
  length_in_samples = int(np.round(sampling_rate_hz * length_in_sec))

  x_data = np.linspace(0.0, length_in_sec, length_in_samples)
  y_data = audio_data[0 : int(length_in_samples), 1] / 32768.0

  return (x_data, y_data, sampling_rate_hz)

# Impulse response

def PerformSTFT(speech_frame, sampling_rate_hz):
  # Adds a routine to calculate FFT size.
  fft_size = 2048
  spectrum = numpy.fft.fft(
      speech_frame * scipy.signal.hamming(len(speech_frame)), fft_size)
  lower_half_spectrum = spectrum[0: int(np.floor(fft_size / 2))]

  freq_data = np.linspace(0.0, sampling_rate_hz / 2.0, len(lower_half_spectrum))

  return (freq_data, lower_half_spectrum)

def GetMinFftSize(signal_length):
  return 2 ** np.ceil(np.log2(signal_length))


def MicrophoneResponseSpectrum(impulse_response, sampling_rate_hz):
  signal_length = len(speech_frame)
  if signal_length <= 0:
    raise ValueError('single length must be positive.')

  impulse_data = np.zeros((signal_length, ))
  index = np.argmax(speech_frame)
  impulse_data[index] = 1.0

  # Constructs the delay signal
  fft_size = int(GetMinFftSize(signal_length))
  delay_spectrum = numpy.fft.fft(
      impulse_data * scipy.signal.hamming(len(impulse_data)), fft_size)
  spectrum = numpy.fft.fft(
      speech_frame * scipy.signal.hamming(len(speech_frame)), fft_size)

  delay_spectrum = numpy.fft.fft(impulse_data, fft_size)
  spectrum = numpy.fft.fft(speech_frame, fft_size)
  spectrum = spectrum / delay_spectrum

  lower_half_spectrum = spectrum[0: np.floor(fft_size / 2)]

  freq_data = np.linspace(0.0, sampling_rate_hz / 2.0, len(lower_half_spectrum))

  return (freq_data, lower_half_spectrum)

kwargs = {}
kwargs["linewidth"] = 1
file_name = sys.argv[1]
(x_data, y_data, sampling_rate_hz) = ObtainSpeechFrame(file_name)
speech_frame = y_data

# Draws waveform plot
file_name = sys.argv[1]
data_list = []
data_list.append((x_data, y_data))
plt.figure(figsize=(8, 3.0))
data_list_plot.PlotContinuousData(data_list, kwargs)
plt.axis([0, 0.1, -0.5, 1.0])
ax = plt.gca()
label = ax.set_xlabel('Xlabel', fontsize = 14)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
ax.set_xticks([0.0, 0.025, 0.05, 0.075])
ax.xaxis.set_label_coords(1.00, -0.02)
fig = plt.gcf()
fig.savefig('impulse_response.eps', dpi=800)


# Draws the magnitude plot (in Decibel)
(x_data, y_data) = MicrophoneResponseSpectrum(y_data, sampling_rate_hz)
spec_data = y_data
mag_data = 20.0 * np.log10(np.abs(spec_data))
data_list = []
data_list.append((x_data, mag_data))
plt.figure(figsize=(8, 3.0))
data_list_plot.PlotContinuousData(data_list, kwargs)
plt.axis([0, 8000, -30.0, 5.0])
ax = plt.gca()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Magnitude (dB)')
ax.set_xticks([0.0, 2000.0, 4000.0, 6000.0])
ax.xaxis.set_label_coords(1.00, -0.02)
label = ax.set_xlabel('Frequency (Hz)', fontsize = 14)
fig = plt.gcf()
fig.savefig('magnitude_response.eps', dpi=800)


# Draws the phase response (in Radians)
data_list = []
phase_data = np.angle(spec_data)
data_list.append((x_data, phase_data))
plt.figure(figsize=(8, 3.0))
data_list_plot.PlotContinuousData(data_list, kwargs)
plt.axis([0, 8000, -np.pi, np.pi])
ax = plt.gca()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Phase (Rad)')
ax.set_xticks([0.0, 2000.0, 4000.0, 6000.0])
ax.xaxis.set_label_coords(1.00, -0.02)
label = ax.set_xlabel('Frequency (Hz)', fontsize = 14)
fig = plt.gcf()
fig.savefig('phase_response.eps', dpi=800)

