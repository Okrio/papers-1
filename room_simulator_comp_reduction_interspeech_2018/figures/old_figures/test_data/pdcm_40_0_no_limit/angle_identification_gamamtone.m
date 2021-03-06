%
% Programmed by Chanwoo Kim
%
% This is the skeleton code for frame-by-frame
% processing. Eventually, it will be replaced by
% classdef version, but the problem is classdef is not
% supported by octave as of now (Apr. 2014).
%
% Parameters
%
% in_file_name  : Input file in wave file format
% out_file_name : Output file in wave file format
% frame_length_sec     : Use 0.05 or 0.075 (50 ms or 75 ms)
%
% * Usage
%     [out_speech] = main_process('sb01_Reverb0P5sec.in.wav', ...
%         'out.wav', 0.1, 0.995, 0.01);
%
%  [out_speech] = main_process('sb01_Clean.in.wav', 'out.wav', 0.05, 0.99, 0.01);

%
% TODO(chanwcom)
% Make the unit test. Before that time, let's test using the following
% commands.
%
function [angle_bias, source_angle_matrix, amplitude_matrix] = angle_identification(...
    in_speech, num_channels, sampling_rate)
  set_path;
  frame_length_sec = 0.075;


  % TODO(chanwcom) Separate them as a separate class.
  % The following are parameters.
  frame_period_sec = 0.01;
  % TODO(chanwcom)
  % Move it to another file defining the constsnts
  speed_of_sound_meters_per_sec = 343.0;
  microphone_distance_meters = 0.02;
  angle_target_threshold = inf; % 30 / 180 * pi; % 30 degrees

  if sampling_rate ~= 16000
      disp(['[WARNING] this algorithm has not been' ...
          'tested other than 16 kHz sampling rate case']);
      % TODO(chanwcom)
      % Don't know whether the following can process multiple columns.
     in_speech = resample(in_speech, 16000, sampling_rate);
  end

  % TODO(chanwcom) Separate the program into three classes
  % File read/processing/file write.
  % The problem is octave currently does not support classdef.
  frame_length = floor(frame_length_sec * sampling_rate);
  frame_period = floor(frame_period_sec * sampling_rate);
  fft_size =  2 ^ceil(log(frame_length) / log(2));
  [signal_length, num_microphones] = size(in_speech);

  assert(num_microphones == 2);

  frame_spectrum = zeros(fft_size,  1);
  frame_half_spectrum = zeros(fft_size / 2, 1);

  % TODO(chanwcom)
  % Instead of padding, consider the first and the last frame
  % as special cases. Separate them as a function.
  padded_in_speech ...
      = [zeros(round(frame_length / 2), num_microphones); ...
          in_speech; ...
          zeros(round(frame_length / 2) , num_microphones)];
  out_speech = zeros(size(padded_in_speech, 1), 1);

  num_frames_padded_in_speech ...
      = floor(length(padded_in_speech - frame_length) / frame_period) + 1;

  source_angle_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);
  amplitude_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);

  if (num_channels > 0)
    cut_off_frequencies = CalculateCutOffFrequencies(...
        0, sampling_rate / 2, num_channels, ...
        fft_size, sampling_rate)
  end

  % Analysis
  window = repmat(hamming(frame_length), 1, num_microphones);
  decimation_factor = frame_length_sec / frame_period_sec;
  ola_factor = mean(window(:, 1)) * decimation_factor

  frame_index = 0;

  in_frame = zeros(frame_period, num_microphones);

  for i = 0 : frame_period : length(padded_in_speech) - frame_length
    in_frame = padded_in_speech(i + 1 : i + frame_length, :) ...
        .* window;
    frame_spectrum  = fft(in_frame, fft_size);
    frame_half_spectrum = frame_spectrum(1 : fft_size / 2 + 1, :);

    source_angle = calculate_angle_from_spectra(...
        frame_half_spectrum( : , 1), ... 
        frame_half_spectrum( : , 2), ... 
        fft_size, ... 
        microphone_distance_meters, ... 
        sampling_rate, ... 
        speed_of_sound_meters_per_sec);

    source_angle_matrix( :, frame_index + 1) = source_angle;
    amplitude_matrix( : , frame_index + 1) = abs(mean(frame_half_spectrum')');

    frame_index = frame_index + 1;
  end

  angle_bias = zeros(fft_size / 2 + 1, 1);

  for l = 1 : num_channels,
    start_index = cut_off_frequencies(l)
    end_index = cut_off_frequencies(l + 1) - 1

    source_angle_channel = source_angle_matrix(start_index + 1 : end_index + 1, :);
    source_angle_channel = source_angle_channel(:);
    amplitude_channel = amplitude_matrix(start_index + 1 : end_index + 1, :);
    amplitude_channel = amplitude_channel(:);

    index = find(abs(source_angle_channel) < angle_target_threshold);

    mean_angle_bias = sum(source_angle_channel(index) .* (amplitude_channel(index) .^ 2)) ...
          / max(sum(amplitude_channel(index) .^ 2), eps)


    angle_bias(start_index + 1 : end_index + 1) = mean_angle_bias;
  end


end

% TODO(chanwcom) Implement it as a library function.
% This method returns the discrete-time index.
function [cut_off_frequencies] = CalculateCutOffFrequencies(...
    low_freq_hertz, high_freq_hertz, num_channels,...
    fft_size, sampling_rate)
  assert(high_freq_hertz > low_freq_hertz);
  assert(num_channels > 0);

  highest_erb = frq2erb(high_freq_hertz);
  lowest_erb = frq2erb(low_freq_hertz);
  cut_off_frequencies_hertz = ...
      erb2frq(linspace(lowest_erb, highest_erb, num_channels + 1));
  cut_off_frequencies = ...
      round(cut_off_frequencies_hertz * fft_size / sampling_rate);

  cut_off_frequencies = max(cut_off_frequencies, 0);
  cut_off_frequencies = min(cut_off_frequencies, fft_size / 2);
end
