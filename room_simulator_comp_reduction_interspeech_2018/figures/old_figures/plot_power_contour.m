window_length = 0.025;
start_frame_index = 300;
end_frame_index = start_frame_index + 199;
channel_index = 14;

path(path, './figure_generation_code');

clean_matrix ... 
    = spectral_analysis( ... 
        'figure_data/sb01_Clean.in.wav', window_length);
reverb_matrix ... 
    = spectral_analysis( ... 
        'figure_data/sb01_Reverb0P5sec.in.wav', window_length);
clean_tmt_matrix ...
    = spectral_analysis( ...
        'figure_data/sb01_Clean.tmt.wav', window_length);
reverb_tmt_matrix ...
    = spectral_analysis(...
        'figure_data/sb01_Reverb0P5sec.tmt.wav', window_length);

plot_data = PlotData();
plot_data = plot_data.set_legend(['b', 'g'])
figure_data = zeros(end_frame_index - start_frame_index + 1, 2);
figure_data(:,  1) = log(clean_matrix(start_frame_index : end_frame_index, channel_index));
figure_data(:,  2) = log(reverb_matrix(start_frame_index : end_frame_index, channel_index));
plot_data.Plot(figure_data);
axis([0 200 -20 30])
set(gca, 'XTick', linspace(0, 200, 5)); 
set(gca, 'XTickLabel', {'0', '0.5', '1.0', '1.5', '2.0'})
set(gca, 'YTick'); 
set(gca, 'YTickLabel', {''})
xlabel('{\it Time (sec)}', 'interpreter', 'latex')
ylabel('{\it Power (dB)}', 'interpreter', 'latex')


%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'power_contour_unprocessed'
  height = 2.0;
  width = 12.0;
  line_width = 2.5;
  font_size = 16.0;

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')

end


figure_data(:,  1) = log(clean_tmt_matrix(start_frame_index : end_frame_index, channel_index));
figure_data(:,  2) = log(reverb_tmt_matrix(start_frame_index : end_frame_index, channel_index));
plot_data.Plot(figure_data);
axis([0 200 -20 30])
set(gca, 'XTick', linspace(0, 200, 5)); 
set(gca, 'XTickLabel', {'0', '0.5', '1.0', '1.5', '2.0'})
set(gca, 'YTick'); 
set(gca, 'YTickLabel', {''})
xlabel('{\it Time (sec)}', 'interpreter', 'latex')
ylabel('{\it Power (dB)}', 'interpreter', 'latex')

%
% TODO(chanwcom) There should be some default class for 
% containing attributes 
if export == 1

% TODO(chanwcom)
%Separate it as a separate class. Encapsulate exportfig as a class
  file_name = 'power_contour_tmt_processed'
if 0
  height = 2.0;
  width = 10.0;
  line_width = 2.5;
  font_size = 16.0;
end

legend(...
    'Clean speech', ...
    'Reverberant speech {\itT_{60} = 500 ms}', ...
    'Location', 'SouthEast');

  export_fig(gcf, file_name, 'width', width, 'height', height, ... 
           'fontmode', 'fixed', 'fontsize', font_size,  ... 
           'color', 'cmyk', 'LineWidth', line_width, 'LineMode', 'fixed')

end


