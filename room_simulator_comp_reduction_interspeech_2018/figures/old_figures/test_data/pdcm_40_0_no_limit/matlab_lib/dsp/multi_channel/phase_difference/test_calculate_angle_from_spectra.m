% This method calculates the azimuth angle of the sound source
% When we have two microphones.
%
% The angle is defined with respect to the perpendicular bisector
% of the line connecting two microphones.
%
% TODO(chanwcom) Make the unit test.
% spectrum_x and spectrum_yh are two spectra


% [spectrum_mat, angle] = test_calculate_angle_from_spectra('testdata/angle_30.wav');
%sum((abs(spectrum_mat(:)) .* angle(:))) / sum((abs(spectrum_mat(:)))) * 180 / pi

function [spectrum_matrix, source_angle_matrix] = test_calculate_angle_from_spectra(in_file_name)

  frame_length_sec = 0.075;
  num_channels = 100;

 [in_speech, sampling_rate] = wavread(in_file_name);
  in_speech = in_speech * 32768;
  % TODO(chanwcom) Separate them as a separate class.
  % The following are parameters.
  frame_period_sec = 0.01;
  % TODO(chanwcom)
  % Move it to another file defining the constsnts
  speed_of_sound_meters_per_sec = 343.0;
  microphone_distance_meters = 0.04;
  angle_threshold = 30 / 180 * pi; % 10 degrees
  angle_target_threshold = 30 / 180 * pi; % 10 degrees
  angle_near_noise_threshold = 60 / 180 * pi; % 20 degrees

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

  window = repmat(hamming(frame_length), 1, num_microphones);

  num_frames = floor((length(padded_in_speech) - frame_length) / frame_period) + 1;
  source_angle_matrix = zeros(num_frames, fft_size / 2 + 1);
  spectrum_matrix = zeros(num_frames, fft_size / 2 + 1);

  frame_index = 0;

 for i = 0 : frame_period : length(padded_in_speech) - frame_length
    in_frame = padded_in_speech(i + 1 : i + frame_length, :) ...
        .* window;
    frame_spectrum  = fft(in_frame, fft_size);
    frame_half_spectrum = frame_spectrum(1 : fft_size / 2 + 1, :);
    average_frame_half_spectrum = mean(frame_half_spectrum')';

    frame_index = frame_index + 1;

    spectrum_matrix(frame_index, : ) = average_frame_half_spectrum;

    source_angle_matrix(frame_index, : ) = calculate_angle_from_spectra(...
        frame_half_spectrum( : , 1), ...
        frame_half_spectrum( : , 2), ...
        fft_size, ...
        microphone_distance_meters, ...
        sampling_rate, ...
        speed_of_sound_meters_per_sec);


  



  end

end
