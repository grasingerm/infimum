function [x, iters, converged] = pattern_search(cost_func,             ... 
                                                line_search_func,      ...
                                                pattern_search_eps,    ...
                                                pattern_search_iters,  ...
                                                line_search_eps,       ...
                                                line_search_iters,     ...
                                                line_search_init_range,...
                                                init_guess,            ... 
                                                pattern_basis,         ...
                                                plot_error_and_path)

%PATTERN_SEARCH Perform a pattern search given a basis and line search
%
%   [x, iters, converged] = PATTERN_SEARCH(cost_func, line_search_func, ...
%                                          pattern_search_eps,          ...
%                                          pattern_search_iters,        ...
%                                          line_search_eps,             ...
%                                          line_search_iters,           ...
%                                          line_search_init_range)
%
%   Pattern search assuming a 2D space and using a positive basis of
%   [1; 0], [0; 1], and [-1; -1]. Min cost until the tolerance given by 
%   pattern_search_eps is met or the number of iterations given by
%   pattern_search_iters is exceeded. Line search for optimal step size
%   at each iteration using the line_search_func, governed by
%   line_search_eps and line_search_iters.
%
%   [x, iters, converged] = PATTERN_SEARCH(cost_func, line_search_func, ...
%                                          pattern_search_eps,          ...
%                                          pattern_search_iters,        ...
%                                          line_search_eps,             ...
%                                          line_search_iters,           ...
%                                          line_search_init_range,      ...
%                                          init_guess)
%
%   Pattern search assuming a 2D space and using a positive basis of
%   [1; 0], [0; 1], and [-1; -1]. Min cost until the tolerance given by 
%   pattern_search_eps is met or the number of iterations given by
%   pattern_search_iters is exceeded. Line search for optimal step size
%   at each iteration using the line_search_func, governed by
%   line_search_eps and line_search_iters.
%
%   [x, iters, converged] = PATTERN_SEARCH(cost_func, line_search_func, ...
%                                          pattern_search_eps,          ...
%                                          pattern_search_iters,        ...
%                                          line_search_eps,             ...
%                                          line_search_iters,           ...
%                                          line_search_init_range,      ...
%                                          init_guess, pattern_basis)
%
%   Pattern search assuming a 2D space and using a positive basis given by
%   the columns of pattern_basis. Min cost until the tolerance given by 
%   pattern_search_eps is met or the number of iterations given by
%   pattern_search_iters is exceeded. Line search for optimal step size
%   at each iteration using the line_search_func, governed by
%   line_search_eps and line_search_iters.
%
%   [x, iters, converged] = PATTERN_SEARCH(cost_func, line_search_func, ...
%                                          pattern_search_eps,          ...
%                                          pattern_search_iters,        ...
%                                          line_search_eps,             ...
%                                          line_search_iters,           ...
%                                          line_search_init_range,      ...
%                                          init_guess, pattern_basis,   ...
%                                          plot_error_and_path)
%
%   Pattern search assuming a 2D space and using a positive basis given by
%   the columns of pattern_basis. Min cost until the tolerance given by 
%   pattern_search_eps is met or the number of iterations given by
%   pattern_search_iters is exceeded. Line search for optimal step size
%   at each iteration using the line_search_func, governed by
%   line_search_eps and line_search_iters. If plot_error_and_path is true, plot
%   the error for each iteration and the path taken by the search.

if nargin < 7
  init_guess = [0; 0];
end

if nargin < 8
  pattern_basis = [1 0 -1;
                   0 1 -1];
else
  assert(size(pattern_basis, 1) == length(init_guess));
end

if nargin < 9
  plot_error_and_path = false;
end

search_range    =   line_search_init_range;
ndirs           =   size(pattern_basis, 2);
x_k             =   init_guess;
prev_cost       =   Inf;
converged       =   false;
E(1)            =   cost_func(x_k);
points(1,:)     =   x_k;

for iter=1:pattern_search_iters

  alphas              =   zeros(ndirs, 1);
  min_j               =   1;
  min_cost            =   Inf;

  for j=1:ndirs
    scalar_cost_func = @(a) cost_func(x_k + a * pattern_basis(:, j)); 
    alphas(j) = line_search_func(scalar_cost_func, search_range, ...
                                 line_search_eps, line_search_iters);

    cost_j = scalar_cost_func(alphas(j));
    if cost_j < min_cost
      min_cost = cost_j;
      min_j = j;
    end
  end

  E(iter+1)           =   min_cost;
  x_k                 =   x_k + alphas(min_j) * pattern_basis(:, min_j);
  points(iter+1, :)   =   x_k;

  if abs(prev_cost - min_cost) < line_search_eps
    converged = true;
    break;
  end
  
  search_range(2)     =   alphas(min_j);
  prev_cost           =   min_cost;
end

iters   =   iter;
x       =   x_k;

if plot_error_and_path
  plot(linspace(0, iters, iters+1), E(1:iters+1));
  title('E vs. iteration');
  figure();
  scatter(points(:,1), points(:,2), linspace(250, 25, iters+1));
  title('Path taken by search');
end

end
