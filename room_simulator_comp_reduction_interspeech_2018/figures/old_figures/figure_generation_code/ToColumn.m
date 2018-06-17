% This method convers a row vector to a column vector
%
% If the input is not a vector but a matrix, then it reports an
% error.
function [in_vector] = ToColumn(in_vector)
  [rows, cols] = size(in_vector);
  assert(rows == 1 || cols == 1);

  if (cols > 1)
    in_vector = in_vector';
  end
end
