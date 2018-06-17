%
% Programmed by Chanwoo Kim
%
% TODO(chanwcom)
% Think about a good name and description.
%
% Parameters
%
% in_file_name  : Input file in wave file format
% out_file_name : Output file in wave file format
% frame_length_sec     : Use 0.05 or 0.075 (50 ms or 75 ms)

%
% test
% [out_speech] = main_process('sb01_Reverb0P5sec.in.wav', ...
%     'out.wav', 0.05);

%
% TODO(chanwcom)
% Make the unit test. Before that time, let's test using the following
% commands.
%
% spectral_analysis(sb01_Clean.in.wav, 'sb01_Clean.out.wav', 0.1, 0.995);
function [power_matrix] = spectral_analysis(...
    in_file_name, frame_length_sec)
  [in_speech, sampling_rate] = wavread(in_file_name);
  in_speech = in_speech * 32768;
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
  filter_bank_response = CalculateGammatoneShapeFilterBankResponse(...
      num_channels, fft_size, sampling_rate, ...
      0.0, sampling_rate / 2.0, true);

  frame_spectrum = zeros(fft_size,  1);
  frame_half_spectrum = zeros(fft_size / 2, 1);

  cmcw_process = CMCWProcess(filter_bank_response);

  % TODO TODO(chanwcom)
  % Instead of doing this, consider the first and the last frame
  % as the special case. And separate it as a function.
  num_frames = floor((signal_length - frame_length) / frame_period) + 1;
  padded_in_speech ... 
      = [zeros(frame_length, 1); in_speech; zeros(frame_length, 1)];
  out_speech = zeros(size(padded_in_speech));

  channel_power = zeros(num_channels, 1);

  num_frames_padded_in_speech ... 
      = floor((length(padded_in_speech) - frame_length) / frame_period) + 1;

  power_matrix = zeros(num_frames_padded_in_speech, num_channels);

  % Analysis
  m = 0;
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
      channel_power(l) = sum(abs(half_frame_spectrum .* filter_bank_response(:, l)) .^ 2);
    end

    
    power_matrix(m + 1, :) = channel_power;
    
    
    m = m + 1;
  end

end
