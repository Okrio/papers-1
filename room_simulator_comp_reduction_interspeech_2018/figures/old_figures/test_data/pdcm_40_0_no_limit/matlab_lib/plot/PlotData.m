%
% Add comments
classdef PlotData
  methods
    % data should be given in columns
    function [obj] = PlotData(obj)
      obj.legend_sequence_ = cell(7, 1);
      obj.legend_sequence_{1} = 'b^-';
      obj.legend_sequence_{2} = 'gv:';
      obj.legend_sequence_{3} = 'rs-.';
      obj.legend_sequence_{4} = 'cd--';
      obj.legend_sequence_{5} = 'mo-';
      obj.legend_sequence_{6} = 'y+:';
      obj.legend_sequence_{7} = 'kx-';
    end

    function [obj] = set_legend(obj, legend_sequence);
      obj.legend_sequence_ = legend_sequence;
    end

    % It is allowed not to set the entire three elements.
    function [obj] = set_title_and_xy_lables_(...
        obj, title_and_xy_lables)
      assert(length(title_and_xy_lables) == 3);
      obj.title_and_xy_labels_
    end

    function [obj] = Plot(obj, data)
      [num_points_in_line, number_of_lines] = size(data);

      assert(number_of_lines <= length(obj.legend_sequence_));

      figure
      hold on
      for i = 1 : number_of_lines
        plot(data(:, i), ... 
            sprintf('%s', obj.legend_sequence_(i)), ...
            'LineWidth', obj.line_width_, ...
            'MarkerSize', obj.marker_size_);
      end
      grid on;
    end

    function [obj] = PlotXY(obj, data)
      [num_points_in_line, number_of_lines] = size(data);

      assert(number_of_lines / 2 <= length(obj.legend_sequence_), ...
          'The number of plots is more than the number of legends');

      figure
      hold on
      m = 0;
      % TODO(chanwcom) Update the code
      for i = 1 : 2 : number_of_lines,
        plot(data(:, i), data(:, i + 1), ... 
            sprintf('%s', obj.legend_sequence_{m + 1}), ...
            'LineWidth', obj.line_width_, ...
            'MarkerSize', obj.marker_size_);
        m = m + 1;
      end
      grid on;
    end
  end

  properties (SetAccess = public)
    legend_sequence_;
    title_and_xy_labels_;
    line_width_ = 2;
    marker_size_ = 5;
  end

end
