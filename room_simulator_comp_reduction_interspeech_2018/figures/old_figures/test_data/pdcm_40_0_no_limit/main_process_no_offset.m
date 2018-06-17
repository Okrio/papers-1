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
%
% filter_bank_type is as follows
% 
% TODO(chanwcom) Couldn't we use either the enumeration type or
% string instead of using the number?
%
% 0 the value is obtained for every frequency index.
% 1, the value is obtained using the rectangular weighting
% 2, the value is obtained using the gammatone weighting
%
% TODO(chanwcom) Implement linear
function [out_speech] = main_process(...
    in_file_name, out_file_name, num_channels, num_channels_offset)
  set_path;
  frame_length_sec = 0.1;

  [in_speech, sampling_rate] = wavread(in_file_name);
  in_speech = in_speech * 32768;
  % TODO(chanwcom) Separate them as a separate class.
  % The following are parameters.
  frame_period_sec = 0.01;
  % TODO(chanwcom)
  % Move it to another file defining the constsnts
  speed_of_sound_meters_per_sec = 343.0;
  microphone_distance_meters = 0.02;
  angle_threshold = 20 / 180 * pi; % 20 degrees
  angle_target_threshold = 20 / 180 * pi; % 10 degrees
  angle_near_noise_threshold = 40 / 180 * pi; % 20 degrees

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

  % The routine cannot handle input if the number of microphones
  % is not four.
  if (num_microphones ~= 4)
    % TODO(chanwcom) Print warning message.
    if num_microphones == 1
      out_speech = in_speech;
    else
      out_speech = mean(in_speech')';
    end 

    wavwrite(out_speech /32768.0, 16000, out_file_name);
    return;
  end 


  frame_spectrum = zeros(fft_size,  1);
  frame_half_spectrum = zeros(fft_size / 2, 1);

  [A, B, C] = calculate_phase_offset(in_speech( :, 2:3), ... 
      16000, ... 
      frame_length_sec, ...
      frame_period_sec, ...
      microphone_distance_meters, ...
      343.0, ...
      0, ...
      20, ...
      num_channels_offset);

%  plot(A * 180 / pi)

  % TODO(chanwcom)
  % Instead of padding, consider the first and the last frame
  % as special cases. Separate them as a function.
  padded_in_speech ...
      = [zeros(round(frame_length / 2), num_microphones); ...
          in_speech; ...
          zeros(round(frame_length / 2) , num_microphones)];
  out_speech = zeros(size(padded_in_speech, 1), 1);

  if (num_channels > 0)
    cut_off_frequencies = CalculateCutOffFrequencies(...
        0, sampling_rate / 2, num_channels, ...
        fft_size, sampling_rate);
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
    frame_half_spectrum(1 : fft_size / 2 + 1, 2) = frame_half_spectrum(1 : fft_size / 2 + 1, 2) .* exp(-j * A); 
    average_frame_half_spectrum = mean(frame_half_spectrum')';

    % TODO (chanwcom)
    % For different mic spacing, implement a function which detects
    % the frequency where the aliasing occurs.
    % But in this implementation, it would not be that necessary.

    continuous_mask = ones(fft_size / 2 + 1, 1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Actual frame-by-frame processing will be implemented here.
    source_angle = calculate_angle_from_spectra(...
        frame_half_spectrum( : , 2), ...
        frame_half_spectrum( : , 3), ...
        fft_size, ...
        microphone_distance_meters, ...
        sampling_rate, ...
        speed_of_sound_meters_per_sec);

    binary_mask = ones(fft_size / 2 + 1, 1);
    index = find(abs(source_angle) > angle_threshold);
    binary_mask(index) = 0;
    if (DetectNoiseFrame( ...
      frame_spectrum, ...
      source_angle, ...
      angle_target_threshold, ...
      angle_near_noise_threshold) == 1)
      %  binary_mask = zeros(fft_size / 2 + 1, 1);
    end
    continuous_mask2 =  BinaryToContinousMask( ...
            binary_mask, ...
            average_frame_half_spectrum, ...
            cut_off_frequencies);

    continuous_mask = max(continuous_mask2, 0.01);
    output_frame_half_spectrum = average_frame_half_spectrum .* continuous_mask;
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    full_output_frame_spectrum ...
      = ([output_frame_half_spectrum(1 : fft_size / 2 + 1); ...
       conj(output_frame_half_spectrum(fft_size / 2: -1 : 2))]);

    out_frame = real(ifft(full_output_frame_spectrum));
    out_speech(i + 1 : i + frame_length)  ...
        = out_speech(i + 1 : i + frame_length) ...
        + 1 / ola_factor * out_frame(1 : frame_length);
    frame_index = frame_index + 1;
  end

  % TODO(chanwcom)
  % It would be better if the first and last frames are processed
  % as special cases inside the main for loop.
  % Remove the padded portions.
  out_speech = out_speech(...
      round(frame_length) / 2 + 1 : ... 
      round(frame_length) / 2 + signal_length);

  % TODO(chanwcom)
  % Separate it as a method.
  % 16 bit assumption
  max_amp = max(abs(out_speech));
  if (max_amp >= 32767.0)
      out_speech = out_speech / max_amp * 32767.0; % To prevent clipping
  end

  % TODO separate it as a sinc class.
  wavwrite(out_speech /32768.0, 16000, out_file_name);
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

% TODO (chanwcom)
% DO separate it for four channels or so.
function [noise_frame] = DetectNoiseFrame(...
    input_spectrum, ...
    source_angle, ...
    angle_target_threshold, ...
    angle_near_noise_threshold)
    near_noise_index ...
        = find(abs(source_angle) > angle_target_threshold ...
        & abs(source_angle) <= angle_near_noise_threshold );
    target_index ...
        = find(abs(source_angle) < angle_target_threshold);

    noise_power = 0.0;
    if (length(near_noise_index) > 0)
      noise_power = sum(abs(input_spectrum(near_noise_index)) .^2);
    end

    target_power = 0.0;
    if (length(target_index) > 0)
      target_power = sum(abs(input_spectrum(target_index)) .^ 2);
    end

    % TODO(chanwcom)
    % This is quite arbitrary. Use the E-M Algorithm instead.
    if (target_power < 2 * noise_power)
      noise_frame = 1;
    else
      noise_frame = 0;
    end
end

function [continuous_mask] = BinaryToContinousMask( ...
    binary_mask, ...
    input_spectrum, ...
    filterbank_cutoff_freq)

    continuous_mask = zeros(size(binary_mask));
    num_channels = length(filterbank_cutoff_freq) - 1;

    for l = 1 : num_channels,
      start_index = filterbank_cutoff_freq(l);
      end_index = filterbank_cutoff_freq(l + 1) - 1;
      channel_range = [start_index : end_index];

      in_channel = input_spectrum(channel_range + 1);
      out_channel = in_channel .* binary_mask(channel_range + 1);

      power_ratio = sum(abs(out_channel) .^ 2) / max(sum(abs(in_channel) .^ 2), eps);

      continuous_mask(channel_range + 1) = sqrt(power_ratio);
    end
    % Because the highest frequency component was not set in the previous
    % for loop.
    continuous_mask(length(continuous_mask)) = sqrt(power_ratio);
    continuous_mask = max(continuous_mask, 0.01);
end



