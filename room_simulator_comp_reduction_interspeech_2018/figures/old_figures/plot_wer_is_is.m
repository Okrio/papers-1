%
% To plot the normalized frequency responses.
wer = [...
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  16.7, 25.1, 33.4, 42.4, 52.7, 61.3, 68.2, 73.0, 76.7;
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  14.3, 22.3, 37.3, 53.9, 69.6, 79.7, 86.4, 90.5, 93.4;
];
wer = wer';
wer(:, 2) = 100 - wer(:, 2);
wer(:, 4) = 100 - wer(:, 4);

% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.8, 0, 100])

legend(...
       'SSF with power normalization', ...
       'Baseline with power normalization', ...
       'Location', 'NorthEast')

%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'wer_is_is_ssf_inf_db';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end

%
% To plot the normalized frequency responses.
wer = [...
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  16.7, 25.1, 33.4, 42.4, 52.7, 61.3, 68.2, 73.0, 76.7;
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  22.7, 32.9, 40.4, 46.8, 56.2, 65.8, 73.3, 78.7, 82.8
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  14.3, 22.3, 37.3, 53.9, 69.6, 79.7, 86.4, 90.5, 93.4;
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  13.9, 22.8, 40.8, 59.1, 75.1, 85.4, 91.3, 94.7, 97.0;
];
wer = wer';
wer(:, 2) = 100 - wer(:, 2);
wer(:, 4) = 100 - wer(:, 4);
wer(:, 6) = 100 - wer(:, 6);
wer(:, 8) = 100 - wer(:, 8);

% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.8, 0, 100])

legend(...
       'SSF with power normalization', ...
       'TMT with power normalization', ...
       'power normalization', ...
       'Baseline', ...
       'Location', 'NorthEast')

%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'wer_is_is_inf_db';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end

%
% To plot the normalized frequency responses.
wer = [...
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  37.7 55.7 65.3 71.6 79.5 85.8 90.5 93.6 95.5;
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  27.1 43.7 62.4 76.9 87.4 93.6 97.3 99.2 100.5;
  0.0,  0.1,  0.2,  0.3,  0.4,  0.5,  0.6,  0.7, 0.8;
  26.3 45.4 67.8 84.8 95.8 101.8 105.3 107.5 108.7;
];
wer = wer';
wer(:, 2) = 100 - wer(:, 2);
wer(:, 4) = 100 - wer(:, 4);
wer(:, 6) = 100 - wer(:, 6);

% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.8, 0, 100])

legend(...
       'TMT with power normalization', ...
       'power normalization', ...
       'Baseline', ...
       'Location', 'NorthEast')
%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'wer_is_is_10dB';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end
