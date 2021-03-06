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
% main_process(sb01_Clean.in.wav, 'sb01_Clean.out.wav', 0.1, 0.99);

function [out_speech] = main_process(...
    in_file_name, out_file_name, frame_length_sec, lambda_factor)
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

  for m = 1 : num_channels
    aad_symH(:, m) = abs([filter_bank_response(:, m); ...
        flipud(filter_bank_response(:, m))]);
  end

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

    % TODO(chanwcom)
    % Make it as a separate class.
    % Consider the first-frame processing as a special case.
    if (m == 0)
      peak_power = abs(half_frame_spectrum);
      bottom_power = abs(half_frame_spectrum);
    end

    index_high = find(abs(half_frame_spectrum) > abs(peak_power));
    index_low = find(abs(half_frame_spectrum) < abs(peak_power));

    peak_power(index_high) ...
        = lambda_factor * abs(half_frame_spectrum(index_high)) ...
            + (1 - lambda_factor) * peak_power(index_high);
    peak_power(index_low) ...
        = (1 - lambda_factor) * abs(half_frame_spectrum(index_low)) ...
            + lambda_factor * peak_power(index_low);

    index_high = find(abs(half_frame_spectrum) > abs(bottom_power));
    index_low = find(abs(half_frame_spectrum) < abs(bottom_power));

    bottom_power(index_high) ...
        = (1 - lambda_factor) * abs(half_frame_spectrum(index_high)) ...
            + lambda_factor * bottom_power(index_high);
    bottom_power(index_low) ...
        =  lambda_factor * abs(half_frame_spectrum(index_low)) ...
            + (1 - lambda_factor) * bottom_power(index_low); 

    % TODO(chanwcom)
    % Separate this as a separate method.
    % Make frequency components zero which decreased compared to
    % the previous value.
    binary_mask = ones(size(half_frame_spectrum));
    [index] = find(abs(half_frame_spectrum) < peak_power);
    binary_mask(index) = 0;

    [cmcw_process, output_spectrum] ...
        = cmcw_process.Process(half_frame_spectrum, binary_mask);

    output_spectrum = max(output_spectrum, bottom_power);
    full_output_spectrum = abs([output_spectrum; ...
        output_spectrum(fft_size / 2 - 1: -1 : 1)]) ...
            .* exp(j * angle(frame_spectrum));
    out_frame = real(ifft(full_output_spectrum));

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
