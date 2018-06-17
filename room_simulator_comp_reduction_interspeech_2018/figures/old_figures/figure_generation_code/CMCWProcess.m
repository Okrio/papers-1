% CMCWProcess
%
% Continous Masking Using Channel Weighting.
%
% This class performs spectral smoothing using the channel weighting
% algorithm. For more detailed information, please refer to the
% following paper. TODO(chanwcom) mentioning the paper.
%
% Usage:
%
% CMCWProcess cmcw_prcess(filter_bank_response)
%
% output_spectrum = cmcw_process.Process(...
%     input_spectrum, binary_mask);
classdef CMCWProcess 
  methods
    % freq_response_set has the following indexes:
    % freq_response_set(frequency_index, channel_index)
    % So, l-th channel is the l-th column.
    % Also note that the frequency response should be from 0 to
    function [obj] = CMCWProcess(freq_response_set)
      [~, num_channels] = size(freq_response_set)
      obj.filter_bank_response_ = zeros(size(freq_response_set));

      % Normalize the filter gain.
      % This procedure is done to make the summation 
      % of the frequency response the unity. After doing
      % this process, the filter bank satisfies the following
      % relationship:
      %
      % \sum_{l = 0}^{L-1} H_l(e^{j \omega_k}) = 1.
      %
      % where L is the number of channels.
      sum_spectrum = sum(freq_response_set')';
      for channel_index = 1 : num_channels,
        obj.filter_bank_response_(:, channel_index) ...
            = freq_response_set(:, channel_index) ... 
                ./ sum_spectrum;
      end
    end

    % The original_spectrum and binary_mask should be given
    % from zero up to N / 2 - 1, where N is the FFT size.
    % We assume that the original signal is a real signal, so
    % we assume that the spectrum satisfies the following symmetry
    % equation.
    function [obj, output_spectrum] = Process(...
        obj, original_spectrum, binary_mask)
        [half_spectrum_length , num_channels]... 
            = size(obj.filter_bank_response_); 

        expected_size = [half_spectrum_length, 1];
      
        assert(all(size(binary_mask) == expected_size), ...
            'The size of "binary mask" is incorrect.\n');
        assert(all(size(original_spectrum) == expected_size), ...
            'The size of "original_spectrum" is incorrect.\n');

        output_spectrum = zeros(size(original_spectrum)); 
        
        % TODO(chanwcom)
        % Spectral integration is done.
        for m = 1 : num_channels;
          channel_spectrum = original_spectrum ...
               .* obj.filter_bank_response_( : , m);
          masked_channel_spectrum = channel_spectrum .* binary_mask; 

          power_ratio = sum(abs(masked_channel_spectrum) .^ 2) ...
              / sum(abs(channel_spectrum) .^ 2);

          output_spectrum = output_spectrum + ...
            sqrt(power_ratio) * channel_spectrum;
        end 
    end

    function [obj, freq_response_set] = freq_response_set(obj)
      freq_response_set = obj.filter_bank_response_;
    end
  end

  properties (SetAccess = private)
    % freq_response_set contains frequency responses in the following
    % format.
    % filter_bank_response_(channel_index, frequency_index)
    filter_bank_response_;

  end
end

