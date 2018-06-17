% This method calculates the azimuth angle of the sound source
% When we have two microphones.
%
% The angle is defined with respect to the perpendicular bisector
% of the line connecting two microphones.
%
% TODO(chanwcom) Make the unit test.
% spectrum_x and spectrum_y are two spectra
function [phase_diff] = calculate_phase_diff_from_spectra(...
    spectrum_left, ... 
    spectrum_right, ... 
    fft_size)
  assert(size(spectrum_left, 1) == fft_size / 2 + 1);
  assert(size(spectrum_left, 2) == 1);
  assert(size(spectrum_right, 1) == fft_size / 2 + 1);
  assert(size(spectrum_right, 2) == 1);

  phase_diff = angle(spectrum_left) - angle(spectrum_right);
  phase_diff = mod(phase_diff + pi, 2 * pi) - pi;
end
