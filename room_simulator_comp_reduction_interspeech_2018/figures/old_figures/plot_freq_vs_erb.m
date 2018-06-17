sampling_rate = 16000;
linear_freq = linspace(0, sampling_rate / 2, 100);
erb_rate = frq2erb(linear_freq);

linear_erb = [linear_freq; erb_rate]';

% Use the PlotData class for plotting. 
plot_data = PlotData();
plot_data = plot_data.set_legend({'b-'});
plot_data.PlotXY(linear_erb);
xlabel('{\it Frequency (Hz)}', 'interpreter', 'latex')
ylabel('{\it ERB scale}', 'interpreter', 'latex')

grid on
%axis([0, 1.2, 0, 100])
%axis([0, 0.9, 0, 100])


%set(gca, 'XTick', linspace(0, 512, 5)); 
%set(gca, 'XTickLabel', {'0', '2000', '4000', '6000', '8000'})

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'plot_freq_vs_erb';
  height = 4.0;
  width = 6.5;
  line_width = 2.5;
  font_size = 14.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')
end
