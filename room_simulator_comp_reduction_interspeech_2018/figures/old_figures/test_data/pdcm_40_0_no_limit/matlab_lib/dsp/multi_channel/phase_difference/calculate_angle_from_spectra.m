% This method calculates the azimuth angle of the sound source
% When we have two microphones.
%
% The angle is defined with respect to the perpendicular bisector
% of the line connecting two microphones.
%
% TODO(chanwcom) Make the unit test.
% spectrum_x and spectrum_y are two spectra
function [source_angle] = calculate_angle_from_spectra(...
    spectrum_left, spectrum_right, fft_size, ...
    microphone_distance_meters, sampling_rate, ...
    speed_of_sound_meters_per_sec)
  assert(size(spectrum_left, 1) == fft_size / 2 + 1);
  assert(size(spectrum_left, 2) == 1);
  assert(size(spectrum_right, 1) == fft_size / 2 + 1);
  assert(size(spectrum_right, 2) == 1);

  phase_diff = angle(spectrum_left) - angle(spectrum_right);

  % The phase difference angle should be between -pi and pi but
  % the above calculation may range from -2 * pi up to 2 * pi.
  indices1 = find(phase_diff < -pi);
  indices2 = find(phase_diff > pi);
  phase_diff(indices1) = phase_diff(indices1) + 2 * pi;
  phase_diff(indices2) = phase_diff(indices2) - 2 * pi;

  % Angle calculation from the phase difference.
  % \tau = \frac{phase_difference}{\omega}
  % where tau is the delay and \omega is the frequency.
  % \omega = 2 \pi k / K where K is the FFT size.
  omega = 2 * pi * (1 : fft_size / 2)' / fft_size;
  delay = zeros(fft_size / 2 + 1, 1);
  delay(1) = 0;
  delay(2 : fft_size / 2 + 1) ...
      = phase_diff(2 : fft_size / 2 + 1) ./ omega;

  % The absolute value of the delay cannot be larger than the 
  % microphone distance. This is the theoretic value, but in
  % reality, the value can be larger than this value. This
  % needs to be corrected.
  delay_max = microphone_distance_meters ...
      / speed_of_sound_meters_per_sec * sampling_rate;
  delay = max(min(delay, delay_max), -delay_max);

  source_angle = asin(delay * speed_of_sound_meters_per_sec ...
      / microphone_distance_meters / sampling_rate);
end
