%
% Programmed by Chanwoo Kim
%
% This is the Matlab code for the Temporal Masking and Thresholding 
% (TMT) algorithm.
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
% TODO(chanwcom)
% Make the unit test. Before that time, let's test using the following
% commands.
%
% main_process(sb01_Clean.in.wav, 'sb01_Clean.out.wav', 0.1, 0.995);
function [peak_sound_level_matrix, sound_level_matrix] = main_process(...
    in_file_name, out_file_name, frame_length_sec, lambda_factor, floor_coeff)

%  [in_speech, sampling_rate] = wavread(in_file_name);
%  in_speech = in_speech * 32768;
  fid = fopen(in_file_name, 'rb');
  fseek(fid, 1024, 'bof');
  in_speech = fread(fid, 'int16');
  fclose(fid);
  % TODO(chanwcom) Separate them as a separate class.
  % The following are parameters.
  frame_period_sec = 0.01;
  sampling_rate = 16000;
  num_channels = 40;

  if sampling_rate ~= 16000
      disp(['[WARNING] this algorithm has not been' ...
          'tested other than 16 kHz sampling rate case']);
     in_speech = resample(in_speech, 16000, sampling_rate);
  end

  % TODO(chanwcom) Separate the program into three classes
  % File read/processing/file write.
  frame_length = floor(frame_length_sec * sampling_rate);
  frame_period = floor(0.01 * sampling_rate);
  fft_size = 2 ^ceil(log(frame_length) / log(2));
  signal_length = length(in_speech);

  % TODO(chanwcom) Separate as a separate class.
  % Gammatone-shape Frequency Response
  filter_bank_freq_responses = CalculateGammatoneShapeFilterBankResponse(...
      num_channels, fft_size, sampling_rate, ...
      0.0, sampling_rate / 2.0, true);

  normalized_filter_bank_freq_responses = ...
      MakeSumOfFreqResonsesUnity(filter_bank_freq_responses);

  frame_spectrum = zeros(fft_size,  1);
  frame_half_spectrum = zeros(fft_size / 2, 1);

  % TODO TODO(chanwcom)
  % Instead of doing this, consider the first and the last frame
  % as the special case. And separate it as a function.
  num_frames = floor((signal_length - frame_length) / frame_period) + 1;
  sound_level_matrix = zeros(num_frames, num_channels);
  peak_sound_level_matrix = zeros(num_frames, num_channels);
  padded_in_speech ... 
      = [zeros(frame_length, 1); in_speech; zeros(frame_length, 1)];
  out_speech = zeros(size(padded_in_speech));

  channel_power = zeros(num_channels, 1);

  % Analysis
  m = 0;
  actual_index = 0;
  window = hamming(frame_length);
  decimation_factor = frame_length_sec / frame_period_sec;
  ola_factor = mean(window) * decimation_factor;
  for i = 0 : frame_period : length(padded_in_speech) - frame_length
    in_frame = padded_in_speech(i + 1 : i + frame_length) ...
        .* window;
    frame_spectrum  = fft(in_frame, fft_size);
    half_frame_spectrum = frame_spectrum(1 : fft_size / 2 + 1);

    % Perform the frequency domain integration.
    for l = 1 : num_channels,
      channel_power(l) = sum(abs(half_frame_spectrum ...
          .* normalized_filter_bank_freq_responses(:, l)) .^ 2);
    end

    % sound_level is after applying the compressive nonlinearity.
    sound_level = channel_power .^ (1 / 15);

    sound_level_matrix(actual_index + 1, : ) = sound_level;

    % TODO(chanwcom)
    % Make it as a separate class.
    % Consider the first-frame processing as a special case.
    if (m == 0)
      peak_sound_level = sound_level;
    end

    %
    peak_sound_level ...
        = max(lambda_factor * peak_sound_level, sound_level);
    peak_sound_level_matrix(actual_index + 1, : ) = peak_sound_level;

    binary_mask = ones(num_channels, 1);
    index = find(sound_level < peak_sound_level);
    binary_mask(index) = 0;

    % Obtain the threshold value.

    binary_mask = max(binary_mask, sqrt((peak_sound_level .^ 15 * floor_coeff) ./ channel_power));

    output_spectrum = zeros(size(half_frame_spectrum));
    for l = 1 : num_channels
      output_spectrum = output_spectrum + ...
        binary_mask(l) * half_frame_spectrum .* normalized_filter_bank_freq_responses(:, l);
    end

    full_output_spectrum = ([output_spectrum; ...
        output_spectrum(fft_size / 2 - 1: -1 : 1)]);

    out_frame = real(ifft(full_output_spectrum));

    if (i >= frame_length)
      actual_index = actual_index + 1;
    end

    % TODO(chanwcom)
    % There might be very slight difference in the output
    % since the first a few and the last a few frames are
    % not overlapped enough. Think about prepending and
    % appending
    % data to prevent this.
    out_speech(i + 1 : i + frame_length)  ...
        = out_speech(i + 1 : i + frame_length) ...
        + 1 / ola_factor * out_frame(1 : frame_length);

    m = m + 1;
  end

  % Removing the first and the last frame.
  out_speech = out_speech(...
      frame_length + 1 : frame_length + signal_length);

  % 16 bit assumption
  max_amp = max(abs(out_speech));
  if (max_amp >= 32767.0)
      out_speech = out_speech / max_amp * 32767.0; % To prevent clipping
  end

  % TODO separate it as a sinc class.
  wavwrite(out_speech /32768.0, 16000, out_file_name);
end
