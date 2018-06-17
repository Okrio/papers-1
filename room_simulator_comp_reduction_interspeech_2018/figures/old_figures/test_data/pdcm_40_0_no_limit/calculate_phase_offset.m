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
% calculate_phase_offset(in_speech, 16000, 0.1, 0.01, 0.02, 343.0, 0.0, 20.0, 100.0); 
function [phase_offset, phase_diff_matrix, power_matrix] = ...
    calculate_phase_offset(...
    in_speech, ... 
    sampling_rate_herz, ...  
    frame_length_sec, ...                     % frame length second : default 0.1 
    frame_period_sec, ...                     % frame period second
    distance_between_microphones_meters, ...  % distance between microphones
    speed_of_sound_meters_per_sec, ...        % speed of sound
    expected_target_angle_degrees, ...         % default zero 
    expected_target_angle_margin_degrees, ...          % \theta_w by default it is 60 degrees.
    num_channels)          
  set_path;


  % TODO(chanwcom)
  % Move it to another file defining the constsnts
  angle_target_threshold = inf; % 30 / 180 * pi; % 30 degrees

  if sampling_rate_herz ~= 16000
      disp(['[WARNING] this algorithm has not been' ...
          'tested other than 16 kHz sampling rate case']);
      % TODO(chanwcom)
      % Don't know whether the following can process multiple columns.
     in_speech = resample(in_speech, 16000, sampling_rate_herz);
  end

  % TODO(chanwcom) Separate the program into three classes
  % File read/processing/file write.
  % The problem is octave currently does not support classdef.
  frame_length = floor(frame_length_sec * sampling_rate_herz);
  frame_period = floor(frame_period_sec * sampling_rate_herz);
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

  phase_diff_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);
  power_matrix = zeros(fft_size / 2 + 1, num_frames_padded_in_speech);

  if (num_channels > 0)
    [cut_off_frequencies, center_frequencies] = CalculateCutOffFrequencies(...
        0, sampling_rate_herz / 2, num_channels, ...
        fft_size, sampling_rate_herz);
  end

  [phi_target_minus, phi_target, phi_target_plus] ...
      = calculate_phase_threshold(...
          sampling_rate_herz, ...
          fft_size, ...
          distance_between_microphones_meters, ...
          speed_of_sound_meters_per_sec, ... 
          expected_target_angle_degrees, ...
          expected_target_angle_margin_degrees);

  phi_target_plus = inf * ones(size(phi_target_plus));
  phi_target_minus = -inf * ones(size(phi_target_minus));

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
    power_frame_half_spectrum = abs(mean(frame_half_spectrum')') .^ 2;

    phase_diff = calculate_phase_diff_from_spectra(...
          frame_half_spectrum( : , 1), ... 
          frame_half_spectrum( : , 2), ... 
          fft_size);

    phase_diff_matrix( :, frame_index + 1) = phase_diff;
    power_matrix( : , frame_index + 1) = power_frame_half_spectrum;

    frame_index = frame_index + 1;
  end

  phase_offset = zeros(fft_size / 2 + 1, 1);
  phase_offset_channel = zeros(num_channels, 1);

  for l = 1 : num_channels,
    start_index = cut_off_frequencies(l);
    end_index = cut_off_frequencies(l + 1) - 1;

    phase_diff_channel = phase_diff_matrix(start_index + 1 : end_index + 1, :);
    [rows, cols] = size(phase_diff_channel);
    phi_target_minus_channel = phi_target_minus(start_index + 1 : end_index + 1);
    phi_target_plus_channel = phi_target_plus(start_index + 1 : end_index + 1);
    phi_target_minus_channel = repmat(phi_target_minus_channel, 1, cols);
    phi_target_plus_channel = repmat(phi_target_plus_channel, 1, cols);

    index = find(phase_diff_channel >= phi_target_minus_channel & ...
        phase_diff_channel <= phi_target_plus_channel);
    phase_diff_channel = phase_diff_channel(index);
    phase_diff_channel = phase_diff_channel(:);

    power_channel = power_matrix(start_index + 1 : end_index + 1, :);
    power_channel = power_channel(index);
    power_channel = power_channel(:);

    if length(index) > 0
      mean_phase_diff = sum(phase_diff_channel .* power_channel) ...
            / max(sum(power_channel), eps);
    else
      mean_phase_diff = phi_target(center_frequencies(l) + 1);
    end

    phase_offset_channel(l) = mean_phase_diff;
  end
  if num_channels > 0
    phase_offset = interp1(center_frequencies, phase_offset_channel, 0:fft_size/2, 'linear'); 
    phase_offset(1 : center_frequencies(1)) = phase_offset(center_frequencies(1) + 1);
    phase_offset(center_frequencies(num_channels) : fft_size / 2 + 1) = phase_offset(center_frequencies(num_channels) + 1);
    phase_offset = phase_offset';
  end

  if num_channels == 0
    for k = 0 : fft_size / 2
      phase_diff_channel = phase_diff_matrix(k + 1, :);
      power_channel = power_matrix(k + 1, :);
      index = find(phase_diff_channel >= phi_target_minus(k + 1) & ...
        phase_diff_channel <= phi_target_plus(k + 1));
    
     if length(index) > 0
      mean_phase_diff = sum(phase_diff_channel(index) .* power_channel(index)) ...
            / max(sum(power_channel(index)), eps)
      else
        mean_phase_diff = phi_target(k + 1);
      end

      phase_offset(k + 1) = mean_phase_diff;
    end
  end

end

% TODO(chanwcom) Implement it as a library function.
% This method returns the discrete-time index.
function [cut_off_frequencies, center_frequencies] = CalculateCutOffFrequencies(...
    low_freq_hertz, high_freq_hertz, num_channels,...
    fft_size, sampling_rate_herz)
  assert(high_freq_hertz > low_freq_hertz);
  assert(num_channels > 0);

  highest_erb = frq2erb(high_freq_hertz);
  lowest_erb = frq2erb(low_freq_hertz);
  width = (highest_erb - lowest_erb) / num_channels;
  cut_off_frequencies_hertz = ...
      erb2frq(linspace(lowest_erb, highest_erb, num_channels + 1));
  center_frequencies_hertz = ...
      erb2frq(linspace(lowest_erb + width / 2, highest_erb - width / 2, num_channels));

  cut_off_frequencies = ...
      round(cut_off_frequencies_hertz * fft_size / sampling_rate_herz);
  center_frequencies = ...
      round(center_frequencies_hertz * fft_size / sampling_rate_herz);

  cut_off_frequencies = max(cut_off_frequencies, 0);
  cut_off_frequencies = min(cut_off_frequencies, fft_size / 2);

  center_frequencies = max(center_frequencies, 0);
  center_frequencies = min(center_frequencies, fft_size / 2);
end
