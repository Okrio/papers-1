%
% TODO(chanwcom)
% 
% Execute this script to set the path of Matlab libraries.
%
% TODO(chanwcom)Update the comment
% TODO(chanwcom)Make a matlab comment template based on this.
% 
% History
% Date          Author      Comment
% Apr 5  2015   chanwcom    Add the voicebox.
% Mar 18 2014   chanwcom    Created

top_directory = './matlab_lib'

% TODO(chanwcom)
% Are there any methods other than sprintf? Something like
% strcat?
path(path, sprintf('%s/speech/voice_activity_detection', top_directory))
path(path, sprintf('%s/speech/normalization', top_directory))
path(path, sprintf('%s/arithmetic', top_directory))
path(path, sprintf('%s/dsp/filter', top_directory))
path(path, sprintf('%s/dsp/multi_channel/phase_difference', top_directory))
path(path, sprintf('%s/dsp/multi_channel/cross_correlation', top_directory))
path(path, sprintf('%s/plot',       top_directory))
path(path, sprintf('%s/export_fig', top_directory))
path(path, sprintf('%s/third_party/voicebox', top_directory))
