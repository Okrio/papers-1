%
% It assumes the input 
%
% Originally made by Chanwoo Kim sometime in 2008 ~ 2009 
% for Samsung project. 
% Modified to support only the RIFF wavefile format.
%
% TODO(chanwcom) Implement a routine which is somewhat similar
% to speech_mr. 
%
% Pass a command line argument which indicates which routine
% to be runned.
function [] = single_wav_vad_speech_part(in_file_name, out_file_name)
  in_speech = wavread(in_file_name);
  out_speech = vad_speech_part(in_speech);
  wavwrite(out_speech / 32768.0, 16000, out_file_name);

  figure
  subplot(2, 1, 1)
  plot(in_speech)
  subplot(2, 1, 2)
  plot(out_speech)
end
