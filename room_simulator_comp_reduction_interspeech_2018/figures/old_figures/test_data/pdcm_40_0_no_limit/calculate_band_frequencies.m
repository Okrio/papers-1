function [frequency_band_hz] = calculate_band_frequencies(...
    frequency_hz, erb_rate_bandwidth)
  assert(erb_rate_bandwidth >= 0);
  assert(frequency_hz >= 0);
  center = frq2erb(frequency_hz);
  erb_band = [center - erb_rate_bandwidth / 2, ...
      center + erb_rate_bandwidth / 2];
  frequency_band_hz = erb2frq(erb_band); 
end

