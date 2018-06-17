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
% TODO(chanwcom) Number of channels will be removed.
%
% example
% calculate_phase_offset(in_speech, 16000, 0.1, 0.01, 0.02, 343.0, 0.0, 30.0, 5.0); 
function [average_phase_diff, band, phase_diff_matrix, power_matrix] = ... 
    calculate_phase_offset(...
    in_speech, ...
    sampling_rate, ...  
    frame_length_sec, ...                     % frame length second : default 0.1
    frame_period_sec, ...                     % frame period second
    distance_between_microphones_meters, ...  % distance between microphones
    speed_of_sound_meters_per_sec, ...        % speed of sound
    expected_target_angle_degree, ...         % default zero 
    expected_target_angle_width_degree, ...          % \theta_w by default it is 60 degrees.
    width_ERB_rate)                           % no default as of now.
  set_path;

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

  % TODO(chanwcom)
  % Instead of padding, consider the first and the last frame
  % as special cases. Separate them as a function.
  padded_in_speech ... 
      = [zeros(round(frame_length / 2), num_microphones); ... 
          in_speech; ... 
          zeros(round(frame_length / 2) , num_microphones)];
  out_speech = zeros(size(padded_in_speech, 1), 1); 

  % Make the frequency band
  band = zeros(fft_size / 2 + 1, 2);
  band_temp = zeros(1, 2);
  continuous_freq = (0 : fft_size / 2) / fft_size * sampling_rate;
  for k = 1 : fft_size / 2 + 1,
    band_temp = calculate_band_frequencies(...
        continuous_freq(k), width_ERB_rate);
    band_temp = fft_size * band_temp / sampling_rate;
    band_temp = max(band_temp, 0.0);
    band_temp = min(band_temp, fft_size / 2);
    band(k, :) = round(band_temp);
  end

  num_frames_padded_in_speech ... 
      = floor(length(padded_in_speech - frame_length) / frame_period) + 1;

  % Obtain the phase threshold
  theta_target_minus = (expected_target_angle_degree - ... 
      expected_target_angle_width_degree / 2) * pi / 180.0;
  theta_target = expected_target_angle_degree * pi / 180.0;
  theta_target_plus = (expected_target_angle_degree + ...
      expected_target_angle_width_degree / 2) * pi / 180.0;

  % g function is defined to be
  % omega_k sin(\theta) f_s d / c_{air}
  omega_k = (2 * pi) * (0 : fft_size / 2)' / fft_size;
  phi_target_minus = omega_k .* sin(theta_target_minus) * sampling_rate ...
      * distance_between_microphones_meters / speed_of_sound_meters_per_sec;
  phi_target = omega_k .* sin(theta_target) * sampling_rate ...
      * distance_between_microphones_meters / speed_of_sound_meters_per_sec;
  phi_target_plus = omega_k .* sin(theta_target_plus) * sampling_rate ...
      * distance_between_microphones_meters / speed_of_sound_meters_per_sec;

  phase_diff_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);
  power_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);
  smoothed_phase_diff_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);
  smoothed_power_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);

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
    avg_frame_half_spectrum = mean(frame_half_spectrum')'; 
    power_frame_half_spectrum = avg_frame_half_spectrum .^ 2;

    phase_diff = calculate_phase_diff_from_spectra(...
        frame_half_spectrum( : , 1), ...
        frame_half_spectrum( : , 2), ...
        fft_size);

    % Find the target index.
    target_freq_index = find(phase_diff >= phi_target_minus & phase_diff < phi_target_plus) - 1;

    % Obtain smoothed phase difference and smoothed power.
    for k = 0 : fft_size / 2,
      if 0
      phase_diff_band = phase_diff(band(k + 1, 1)  + 1: band(k + 1, 2) + 1);
      target_band_index = find(band(k + 1, 1) <= target_freq_index & ...
          target_freq_index <= band(k + 1, 2));
      if (length(target_band_index > 0)) 
        smoothed_power_matrix(k + 1, frame_index + 1) = mean(avg_frame_half_spectrum(target_band_index)); 
        smoothed_phase_diff_matrix(k + 1, frame_index + 1) = ...
          sum(phase_diff(target_band_index) .* avg_frame_half_spectrum(target_band_index)) ...
            / sum(avg_frame_half_spectrum(target_band_index));
      else
        smoothed_power_matrix(k + 1, frame_index + 1) = 0;
        smoothed_phase_diff_matrix(k + 1, frame_index + 1) = 0;
      end
      end
    end

    frame_index = frame_index + 1;
  end

  % Final average
  average_phase_diff = zeros(fft_size / 2 + 1, 1); 
  for k = 0 : fft_size,
    sum_power = sum(power_matrix(k+ 1, :));
    if (sum_power > 0)
      average_phase_diff(k + 1) =sum(phase_diff_matrix(k + 1 , :) .* power_matrix(k + 1, :)) ...
        / sum(power_matrix(k + 1, :));
    else
      average_phase_diff(k + 1) = phi_target(k + 1); 
    end
  end
end

