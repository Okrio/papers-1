% This method converts the lower half of the spectrum to the full 
% spectrum assuming that the signal is a real signal. Note that
% if a signal is a real signal, then the following assumption
% holds:
%
% X(e ^ {j  \omega}) = X(e ^ {j (pi - \omega)}
%
% 0 to N / 2 where N is the number of frequency components.
%
% The half spectrum is given from 0 \le k \le N / 2
%

function [full_spectrum] = HalfSpectrumToFullSpectrum(half_spectrum)
  half_spectrum = ToColumn(half_spectrum);

  full_spectrum = [half_spectrum(1 : length(half_spectrum) - 1); ... 
      half_spectrum(length(half_spectrum)); ...
      half_spectrum(length(half_spectrum) - 1 : -1 : 1)];
end
