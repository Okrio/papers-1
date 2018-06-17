%
% To plot the normalized frequency responses.
filter_bank_freq_responses ...
    = CalculateGammatoneShapeFilterBankResponse( ...
        40, 1024, 16000, 0, 8000, true);
normalized_filter_bank_responses ...
    = MakeSumOfFreqResonsesUnity(filter_bank_freq_responses);

% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data = plot_data.set_legend(repmat('b^', 40, 1));
plot_data.Plot(normalized_filter_bank_responses);
xlabel('{\it Frequency (Hz)}', 'interpreter', 'latex')
ylabel('{\it Frequency response}', 'interpreter', 'latex')

grid on
axis([0, 512, 0, 1])
set(gca, 'XTick', linspace(0, 512, 5)); 
set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'draw_filter_bank_responses';
  height = 4.0;
  width = 6.0;
  line_width = 2.5;
  font_size = 16.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end

