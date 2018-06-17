function [delay] = analyze_delay(in_data, up_sampling_factor)
  if (nargin == 1)
      up_sampling_factor = 1;
      in_upsampled_data = in_data;
  elseif (nargin == 2)
    assert(up_sampling_factor >= 1);
    in_upsampled_data = resample(in_data, up_sampling_factor, 1);
  end

  [signal_length, num_microphones] = size(in_upsampled_data)

  assert(signal_length > num_microphones);

  reference_signal = in_upsampled_data(:, 1);

  delay = zeros(num_microphones, 1);

  center_of_corr_index = signal_length;

  for m = 2 : num_microphones
    corr_signal = xcorr(reference_signal, in_upsampled_data(:, m));
    [val, index] = max(corr_signal);

    delay(m) = center_of_corr_index - index; 
  end

  delay = delay / up_sampling_factor;

end
