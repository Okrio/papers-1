% TODO (chanwcom)
%
% As of now, it is not using the unit test framework defined in Matlab.
%
function [] = SumTest()

end

function [] = ProcessCMCWTest()

  gammatone_response = ComputeFilterResponse(iNumFilts, 
  
  % TODO(chanwcom) Replace the following by a general filter bank
  % response class. Consider the factory pattern.
  num_channels = 40; 
  fft_size = 512;
  low_freq = 0;
  high_freq = 8000;
  sampling_rate = 16000;

  freq_response_set = ComputeFilterResponse(...
    num_channels, fft_size, low_freq, high_freq, sampling_rate);



end
