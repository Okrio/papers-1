%
% TODO(chanwcom)
% Make a unit test.
%
% This method scales the input speech to make it
% have the specified Root Mean Square (RMS) power.
function [in_speech] = power_norm(in_speech, rms_power)
  rms_power_in_speech = sqrt(mean(in_speech .^ 2));
  assert(rms_power_in_speech > 0.0);
  in_speech = in_speech * (rms_power / rms_power_in_speech);
end 
