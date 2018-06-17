%
% To plot the normalized frequency responses.
rm_wer = [...
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  7.4 10.9 12.8 14.2 17.1 20.2 24.9 34.0 40.1; ... % TMT
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  6.7 10.8 13.9 17.6 22.5 27.1 30.7 40.0 44.0; ... % SSF
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  7.9, 9.2, 17.1, 30.5, 43.6, 52.8, 60.4, 68.9,73.3 % LTLSS (Update the result)
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  6.8 10.3 21.8 38.0 50.5 58.8 63.7 71.8 74.7; ... % VTS
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  6.8 9.7 21.6 37.9 50.5 58.9 63.6 71.8 74.7; ... % MFCC
];
rm_wer = rm_wer';
rm_wer(:, 2) = 100 - rm_wer(:, 2);
rm_wer(:, 4) = 100 - rm_wer(:, 4);
rm_wer(:, 6) = 100 - rm_wer(:, 6);
rm_wer(:, 8) = 100 - rm_wer(:, 8);
rm_wer(:, 10) = 100 - rm_wer(:, 10);


% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(rm_wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.9, 0, 100])

legend(...
       'TMT', ...
       'SSF', ...
       'LTLSS', ...
       'VTS', ...
       'Baseline MFCC', ...
       'Location', 'SouthWest');

%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'plot_wer_rm';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end



wsj_wer = [...
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  18.2 25.4 29.5 34.6 42.2 49.7 59.0 74.4 79.8; ... % TMT
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  17.2 21.1 27.8 37.8 47.7 57.7 64.9 79.8 86.3; ... % SSF
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  15.7 22.3 48.0 73.8 86.7 92.2 94.4 96.3 96.5; ... % ltlss
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  13.2 20.4 43.2 69.3 84.4 91.4 94.0 97.8 98.0;  % VTS
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  12.4 20.4 43.1 69.6 84.5 91.2 93.7 97.7 97.8;  % MFCC
];
wsj_wer = wsj_wer';
wsj_wer(:, 2) = 100 - wsj_wer(:, 2);
wsj_wer(:, 4) = 100 - wsj_wer(:, 4);
wsj_wer(:, 6) = 100 - wsj_wer(:, 6);
wsj_wer(:, 8) = 100 - wsj_wer(:, 8);
wsj_wer(:, 10) = 100 - wsj_wer(:, 10);


% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(wsj_wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.9, 0, 100])

legend(...
       'TMT', ...
       'SSF', ...
       'LTLSS', ...
       'VTS', ...
       'Baseline MFCC', ...
       'Location', 'NorthEast');

%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'plot_wer_wsj';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')

end
%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'plot_wer_rm';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end



wsj_wer = [...
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  14.5 21.4 28.6 33.7 41.5 50.2 59.9 75.3 82.4; ... % TMT (with VAD)
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  18.2 25.4 29.5 34.6 42.2 49.7 59.0 74.4 79.8; ... % TMT (without VAD)
  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9, 1.2; ... % x-axis
  12.4 20.4 43.1 69.6 84.5 91.2 93.7 97.7 97.8;  % MFCC
];
wsj_wer = wsj_wer';
wsj_wer(:, 2) = 100 - wsj_wer(:, 2);
wsj_wer(:, 4) = 100 - wsj_wer(:, 4);
wsj_wer(:, 6) = 100 - wsj_wer(:, 6);


% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data.PlotXY(wsj_wer);
xlabel('{\it Reverberation time $T_{60}$ (ms)}', 'interpreter', 'latex')
ylabel('{\it Accuracy (100 -WER)}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
axis([0, 0.9, 0, 100])

legend(...
       'TMT (with VAD)', ...
       'TMT (without VAD)', ...
       'Baseline MFCC', ...
       'Location', 'NorthEast');

%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'plot_wer_wsj_with_vad';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end
