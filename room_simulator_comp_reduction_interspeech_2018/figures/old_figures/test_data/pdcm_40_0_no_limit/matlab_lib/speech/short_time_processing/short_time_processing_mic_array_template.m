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
% TODO(chanwcom) Try to combine it with the other "template" one.

%
% TODO(chanwcom)
% Make the unit test. Before that time, let's test using the following
% commands.
%
% main_process(sb01_Clean.in.wav, 'sb01_Clean.out.wav', 0.1, 0.99, 0.01);
function [out_speech] = main_process(...
    in_file_name, out_file_name, frame_length_sec, num_channels)
  set_path;

  [in_speech, sampling_rate] = wavread(in_file_name);
  in_speech = in_speech * 32768;
  % TODO(chanwcom) Separate them as a separate class.
  % The following are parameters.
  frame_period_sec = 0.01;

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
  fft_size = 2 ^ceil(log(frame_length) / log(2));
  [signal_length, num_microphones] = size(in_speech); 

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

  % Analysis
  window = hamming(frame_length);
  decimation_factor = frame_length_sec / frame_period_sec;
  ola_factor = mean(window) * decimation_factor

  frame_index = 0;

  for i = 0 : frame_period : length(padded_in_speech) - frame_length
    in_frame = padded_in_speech(i + 1 : i + frame_length, 1) ...
        .* window;
    frame_spectrum  = fft(in_frame, fft_size);
    frame_half_spectrum = frame_spectrum(1 : fft_size / 2 + 1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Actual frame-by-frame processing will be implemented here.
    output_frame_half_spectrum = frame_half_spectrum;
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
