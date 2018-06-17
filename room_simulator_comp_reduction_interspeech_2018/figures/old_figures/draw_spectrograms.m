figure;

clean_speech = wavread('figure_data/sb01_Clean.in.wav');
reverb_speech = wavread('figure_data/sb01_Reverb0P5sec.in.wav');
tmt_speech = wavread('figure_data/sb01_Reverb0P5sec.tmt.wav');

sampling_rate = 16000;
start_index = sampling_rate * 3.0;
end_index = sampling_rate * 5.0;
portion = [start_index : end_index];

if 0
  subplot(4, 1, 1)
  spectrogram(clean_speech(portion), hamming(160), 80, 1024, sampling_rate); view(90, -90);

  subplot(4, 1, 2)
  spectrogram(reverb_speech(portion), hamming(160),80, 1024, sampling_rate); view(90, -90);

  subplot(4, 1, 3)
  spectrogram(ssf_speech(portion), hamming(160), 80, 1024, sampling_rate); view(90, -90);

  subplot(4, 1, 4)
  spectrogram(tmt_speech(portion), hamming(160), 80, 1024, sampling_rate); view(90, -90);
end 

figure
spectrogram(clean_speech(portion), hamming(160), 80, 1024, sampling_rate); view(90, -90);
ylabel('Time (s)')
%title('Clean speech');

if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'clean_speech_spectrogram';
  height = 2.0;
  width = 7.0;
  line_width = 2.5;
  font_size = 6.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'scaled')
end


figure
spectrogram(reverb_speech(portion), hamming(160),80, 1024, sampling_rate); view(90, -90);
%title('Reverberant speech when $T_{60}$ is 500 ms')

ylabel('Time (s)')

if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'reverb_speech_spectrogram';
  height = 2.0;
  width = 7.0;
  line_width = 2.5;
  font_size = 6.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'scaled')
end

figure
spectrogram(tmt_speech(portion), hamming(160), 80, 1024, sampling_rate); view(90, -90);
%title('TMT-processed speech when $T_{60}$ is 500 ms')
ylabel('Time (s)')

if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'tmt_reverb_speech_spectrogram';
  height = 2.0;
  width = 7.0;
  line_width = 2.5;
  font_size = 6.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'scaled')
end
