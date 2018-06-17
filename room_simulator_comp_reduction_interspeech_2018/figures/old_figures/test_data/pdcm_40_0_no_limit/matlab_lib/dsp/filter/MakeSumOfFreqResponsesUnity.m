%
% This procedure makes the sum of frequency responses unity.
% This characteristic can be expressed in the following equation:
%
% \sum_{l = 0}^{L-1} H_l(e^{j \omega_k}) = 1.
%
% where L is the number of channels, and \omega_k is the discrete-
% requency.
%
% The following operation is done for this purpose..
% TODO(chanwcom) write down the equation.
%
% TODO(chanwcom) Make the unit test.
%
% in_filter_bank_responses, the frequency responses in each channel
% should be stored in each column. 
function [out_filter_bank_responses] = MakeSumOfFreqResponsesUnity(...
    in_filter_bank_responses)
  [response_size, num_channels] = size(in_filter_bank_responses); 
     
  out_filter_bank_responses = zeros(size(in_filter_bank_responses));
  sum_spectrum = sum(abs(in_filter_bank_responses)')';
  for channel_index = 1 : num_channels,
    out_filter_bank_responses(:, channel_index) ... 
        = abs(in_filter_bank_responses(:, channel_index)) ... 
            ./ sum_spectrum;
  end 
end
