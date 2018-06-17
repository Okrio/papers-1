%
% TODO(chanwcom)
% 
% Rename the variables to follow the coding convention.
function center_frequency_array = compute_erb_space(low_freq, high_freq, N)
% center_frequency_array = ComputeERBSpace(low_freq, high_freq, N)
% function center_frequency_array = ERBSpace(low_freq, high_freq, N)
% This function computes an array of N frequencies uniformly spaced between
% high_freq and low_freq on an ERB scale.  N is set to 100 if not specified.
%
% See also linspace, logspace, MakeERBCoeffs, MakeERBFilters.
%
% For a definition of ERB, see Moore, B. C. J., and Glasberg, B. R. (1983).
% "Suggested formulae for calculating auditory-filter bandwidths and 
% excitation patterns," J. Acoust. Soc. Am. 74, 750-753.
  if nargin < 1 
      low_freq = 100;
  end 

  if nargin < 2 
      high_freq = 44100/4;
  end 

  if nargin < 3 
      N = 100;
  end 

  % Change the following three parameters if you wish to use a different
  % ERB scale.  Must change in MakeERBCoeffs too.
  EarQ = 9.26449;       %  Glasberg and Moore Parameters
  minBW = 24.7;
  order = 1;

  % All of the follow_freqing expressions are derived in Apple TR #35, "An 
  % Efficient Implementation of the Patterson-Holdsworth Cochlear
  % Filter Bank."  See pages 33-34.
  center_frequency_array = -(EarQ*minBW) + ... 
      exp((1:N)'*(-log(high_freq + EarQ*minBW) + ... 
      log(low_freq + EarQ*minBW))/N) * (high_freq + EarQ*minBW);

end

