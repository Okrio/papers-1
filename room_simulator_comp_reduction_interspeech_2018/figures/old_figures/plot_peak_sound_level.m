window_length = 0.025;
start_frame_index = 300; 
end_frame_index = start_frame_index + 199;
channel_index = 20;

path(path, './figure_generation_code');

[peak_sound_level_matrix, sound_level_matrix] ... 
    = obtain_peak_sound_countour(...
        'sb01_Clean.in.wav', 'tmp.wav', ... 
            0.5, 0.99, 0.01);


plot_data = PlotData();
plot_data = plot_data.set_legend(['b', 'g'])
figure_data = zeros(end_frame_index - start_frame_index + 1, 2);
figure_data(:,  1) = 10 * log10((sound_level_matrix(start_frame_index : end_frame_index, channel_index)) .^ 15);
figure_data(:,  2) = 10 * log10((peak_sound_level_matrix(start_frame_index : end_frame_index, channel_index)) .^ 15);
plot_data.Plot(figure_data);
%axis([0 200 -20 30])
set(gca, 'XTick', linspace(0, 200, 5)); 
%set(gca, 'XTickLabel', {'0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0', '3.5', '4.0', '4.5', '5.0'})
set(gca, 'XTickLabel', {'0', '0.5', '1.0', '1.5', '2.0'})%, '2.5', '3.0', '3.5', '4.0', '4.5', '5.0'})
set(gca, 'YTick'); 
set(gca, 'YTickLabel', {''})
xlabel('{\it Time (sec)}', 'interpreter', 'latex')
ylabel('{\it Power (in dB)}', 'interpreter', 'latex')

 legend(...
      'Sound level', ...
      'Peak sound level', ...
      'Location', 'SouthWest');

if  export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'sound_level_and_peak_sound_level';
  height = 2.5
  width = 12.0;
  line_width = 2.5;
  font_size = 16.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')

end


