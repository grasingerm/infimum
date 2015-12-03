function [alpha, range, iters, converged] = ...
  line_search_golden(func_handle, init_range, eps, max_iters, plot_error)
%LINE_SEARCH_GOLDEN Perform line search using method of golden section
%
%   [alpha, range, iters, converged] = LINE_SEARCH_GOLDEN(func_handle, ...
%                                                         init_range,  ...
%                                                         eps,         ...
%                                                         max_iters,   ...
%                                                         plot_error)
%
%   Line search using method of golden section until the range is smaller 
%   than the tolerance provided by the input eps, or until the maximum 
%   number of iterations has been reached. Cost function is given by the 
%   handle func_handle.

rho = (sqrt(5) - 1) / 2;

if nargin < 5
  plot_error = false;
end

y = zeros(2, 1);
range = init_range;
converged = false;

a = range(2) - rho * (range(2) - range(1));
b = range(1) + rho * (range(2) - range(1));
y(1) = func_handle(a);
y(2) = func_handle(b);

if plot_error
  ranges = zeros(50, 2);
  ranges(1,:) = init_range;
  Es = zeros(50, 1);
  for iters = 1:max_iters
    if y(1) < y(2)
      Es(iters) = y(1);
      range(2) = b;
      b = a;
      a = range(2) - rho * (range(2) - range(1));
      y(2) = y(1);
      y(1) = func_handle(a);
    else
      Es(iters) = y(2);
      range(1) = a;
      a = b;
      b = range(1) + rho * (range(2) - range(1));
      y(1) = y(2);
      y(2) = func_handle(b);
    end

    if range(2) - range(1) < eps;
      converged = true;
      break;
    end
    
    ranges(iters+1,:) = range;
  end
  
  Es(iters+1) = min(y);
  xs = linspace(0, iters, iters+1);
  plot(xs, Es(1:iters+1));
  title('Error vs. Iterations');
  figure();
  
  hold on;
  for i=1:iters
    xs = linspace(ranges(i,1), ranges(i,2), 100);
    ys = ones(100, 1) * (i-1);
    plot(xs, ys);
  end
  title('Range at each Iteration');
else
  for iters = 1:max_iters-1
    if y(1) < y(2)
      range(2) = b;
      b = a;
      a = range(2) - rho * (range(2) - range(1));
      y(2) = y(1);
      y(1) = func_handle(a);
    else
      range(1) = a;
      a = b;
      b = range(1) + rho * (range(2) - range(1));
      y(1) = y(2);
      y(2) = func_handle(b);
    end

    if range(2) - range(1) < eps;
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

end

