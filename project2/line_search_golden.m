function [x_k, alpha, range, iters, converged] = ...
  line_search_golden(func_handle, init_range, x_0, d, eps, max_iters, ...
                     plot_error)
%LINE_SEARCH_GOLDEN Perform line search using method of golden section
%
%   [alpha, range, iters, converged] = LINE_SEARCH_GOLDEN(func_handle, ...
%                                                         d, range_0,  ...
%                                                         eps,         ...
%                                                         max_iters,   ...
%                                                         plot_error)
%
%   Line search using method of golden section, in the direction given by
%   vector d, until the range is smaller than the tolerance provided by the 
%   input eps, or until the maximum number of iterations has been reached. 
%   Cost function is given by the handle func_handle.

if nargin < 7
  plot_error = false;
end

y = zeros(2, 1);
range = init_range;
converged = false;

diff = range(2) - range(1);
a = 0.38 * diff;
b = 0.62 * diff;
y(1) = func_handle(x_0 + a * d);
y(2) = func_handle(x_0 + b * d);

if plot_error
  Es = zeros(max_iters, 1);
  
  for iters = 1:max_iters-1
    if y(1) < y(2)
      Es(iters) = y(1);
      range(2) = b;
      b = 0.62 * (range(2) - range(1)) + range(1);
      y(2) = func_handle(x_0 + b * d);
    else
      Es(iters) = y(2);
      range(1) = a;
      a = 0.38 * (range(2) - range(1)) + range(1);
      y(1) = func_handle(x_0 + a * d);
    end

    if range(2) - range(1) < eps
      converged = true;
      break;
    end
  end
  
  iters = iters+1;
  Es(iters) = min(y);
  xs = linspace(1, iters, iters);
  plot(xs, Es(1:iters));
else
  for iters = 1:max_iters-1
    if y(1) < y(2)
      Es(iters) = y(1);
      range(2) = b;
      b = 0.62 * (range(2) - range(1)) + range(1);
      y(2) = func_handle(x_0 + b * d);
    else
      Es(iters) = y(2);
      range(1) = a;
      a = 0.38 * (range(2) - range(1)) + range(1);
      y(1) = func_handle(x_0 + a * d);
    end

    if range(2) - range(1) < eps
      converged = true;
      break;
    end
  end
end

if y(1) < y(2)
  alpha = a;
else
  alpha = b;
end

x_k = x_0 + alpha * d;

end

