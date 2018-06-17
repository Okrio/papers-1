#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
import numpy.fft
import os
import os.path
import sys
import scipy.io.wavfile
import scipy.signal

from plot_util import data_list_plot
from dsp.multi_channel import phase_difference_util


def ObtainSpeechFrame(file_name):
  assert(os.path.exists(file_name))

  (sampling_rate_hz, audio_data) = scipy.io.wavfile.read(file_name)

  length_in_sec = 0.10
  length_in_samples = int(np.round(sampling_rate_hz * length_in_sec))

  x_data = np.linspace(0.0, length_in_sec, length_in_samples)
  y_data = audio_data[0 : int(length_in_samples)] / 32768.0

  return (x_data, y_data, sampling_rate_hz)

def GetMinFftSize(signal_length):
  return 2 ** np.ceil(np.log2(signal_length))

def MicrophoneResponseSpectrum(impulse_response, sampling_rate_hz):
  (signal_length, num_channels) = np.shape(impulse_response)
  if signal_length <= 0:
    raise ValueError('single length must be positive.')

  # Constructs the delay signal
  impulse_data = np.zeros((signal_length, 1))
  (sample_index, channel_index) = np.unravel_index(
      impulse_response.argmax(), impulse_response.shape)
  impulse_data[sample_index, 0] = 1.0
  print sample_index

  impulse_data = np.repeat(impulse_data, num_channels, axis=1)
  window_signal = np.repeat(
      np.expand_dims(
          scipy.signal.hamming(signal_length), axis=1), num_channels, axis=1)

  fft_size = int(GetMinFftSize(signal_length))
  delay_spectrum = np.fft.fft(
      impulse_data * window_signal, fft_size, axis=0)
  spectrum = np.fft.fft(
      impulse_response * window_signal, fft_size, axis=0)

  # Compensates the delay component.
  spectrum = spectrum / delay_spectrum
  lower_half_spectrum = spectrum[0: int(np.floor(fft_size / 2) + 1), :]
  freq_data = np.linspace(0.0, sampling_rate_hz / 2.0, len(lower_half_spectrum))

  return (freq_data, lower_half_spectrum)

def PlotFigure(file_name, out_postfix):
  (x_data, y_data, sampling_rate_hz) = ObtainSpeechFrame(file_name)
  kwargs = {}
  kwargs["linewidth"] = 2
  speech_frame = y_data
  data_list = []
  data_list.append((x_data, y_data[:, 0]))
  plt.figure(figsize=(8, 3.0))
  data_list_plot.PlotSolidContinuousData(data_list, kwargs)
  plt.axis([0, 0.1, -0.5, 1.0])
  ax = plt.gca()
  label = ax.set_xlabel('Xlabel', fontsize = 14)
  plt.xlabel('Time (s)')
  plt.ylabel('Amplitude')
  ax.set_xticks([0.0, 0.025, 0.05, 0.075])
  ax.xaxis.set_label_coords(1.00, -0.02)
  fig = plt.gcf()
  outfile_name = "time_domain_response_" + out_postfix + ".eps"
  fig.savefig(outfile_name, dpi=800)


  # Draws the magnitude plot (in Decibel)
  (x_data, y_data) = MicrophoneResponseSpectrum(y_data, sampling_rate_hz)
  spec_data = y_data
  mag_data = 20.0 * np.log10(np.abs(spec_data))
  data_list = []
  data_list.append((x_data, mag_data[:, 0], 'Channel 0'))
  data_list.append((x_data, mag_data[:, 2], 'Channel 1'))
  plt.figure(figsize=(8, 3.0))
  data_list_plot.PlotSolidContinuousData(data_list, kwargs)
  plt.axis([0, 8000, -30.0, 5.0])
  ax = plt.gca()
  plt.xlabel('Frequency (Hz)')
  plt.ylabel('Magnitude (dB)')
  ax.set_xticks([0.0, 2000.0, 4000.0, 6000.0])
  ax.xaxis.set_label_coords(1.00, -0.02)
  label = ax.set_xlabel('Frequency (Hz)', fontsize = 14)
  fig = plt.gcf()
  outfile_name = "magnitude_response_" + out_postfix + ".eps"
  fig.savefig(outfile_name, dpi=800)


  # Draws the phase response (in Radians)
  phase_data = np.angle(spec_data)
  data_list = []
  data_list.append((x_data, phase_data[:, 0], 'Channel 0'))
  data_list.append((x_data, phase_data[:, 2], 'Channel 1'))
  plt.figure(figsize=(8, 3.0))
  data_list_plot.PlotSolidContinuousData(data_list, kwargs)
  plt.axis([0, 8000, -np.pi, np.pi])
  ax = plt.gca()
  plt.xlabel('Frequency (Hz)')
  plt.ylabel('Phase (Rad)')
  ax.set_xticks([0.0, 2000.0, 4000.0, 6000.0])
  ax.xaxis.set_label_coords(1.00, -0.02)
  label = ax.set_xlabel('Frequency (Hz)', fontsize = 14)
  fig = plt.gcf()
  outfile_name = "phase_response_" + out_postfix + ".eps"
  fig.savefig(outfile_name, dpi=800)

  # Draws the angle
  print len(spec_data[:, 0])
  print len(spec_data[:, 2])
  angle_data = phase_difference_util.SpectraToSourceAngleDegrees(
      spec_data[:, 0], spec_data[:, 2], 16000.0, 0.051, 2048)
  data_list = []
  data_list.append((x_data, angle_data))
  plt.figure(figsize=(8, 3.0))
  data_list_plot.PlotSolidContinuousData(data_list, kwargs)
  plt.axis([0, 8000, -100.0, 100.0])
  ax = plt.gca()
  plt.xlabel('Frequency (Hz)')
  plt.ylabel('Angle (degrees)')
  ax.set_xticks([0.0, 2000.0, 4000.0, 6000.0])
  ax.set_yticks([-90.0, -45.0, 0.0, 45.0, 90.0])
  ax.xaxis.set_label_coords(1.00, -0.02)
  label = ax.set_xlabel('Frequency (Hz)', fontsize = 14)
  fig = plt.gcf()
  outfile_name = "estimated_angle_" + out_postfix + ".eps"
  fig.savefig(outfile_name, dpi=800)


if __name__ == "__main__":
  assert(len(sys.argv) == 2)

  postfix = os.path.splitext(os.path.basename(sys.argv[1]))[0]
  PlotFigure(sys.argv[1], postfix)
