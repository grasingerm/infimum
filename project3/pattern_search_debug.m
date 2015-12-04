function [x, iters, converged] = pattern_search_debug(                 ...
                                                cost_func,             ... 
                                                line_search_func,      ...
                                                pattern_search_eps,    ...
                                                pattern_search_iters,  ...
                                                line_search_eps,       ...
                                                line_search_iters,     ...
                                                line_search_init_range,...
                                                init_guess,            ... 
                                                pattern_basis,         ...
                                                plot_error_and_path)

disp('Setting up pattern search');
tic();

if nargin < 7
  disp('Setting init_guess to default');
  init_guess = [0; 0]
end

if nargin < 8
  disp('Setting pattern_basis to default');
  pattern_basis = [1 0 -1;
                   0 1 -1]
else
  assert(size(pattern_basis, 1) == length(init_guess));
end

if nargin < 9
  plot_error_and_path = false;
end

search_range    =   line_search_init_range
ndirs           =   size(pattern_basis, 2)
x_k             =   init_guess
prev_cost       =   Inf
converged       =   false
E(1)            =   cost_func(x_k)
points(1,:)     =   x_k

disp('Setup complete');
toc();

tic();
disp('---');
disp('Starting pattern seach...');

for iter=1:pattern_search_iters

  disp(['Iteration ', num2str(iter)]);

  alphas              =   zeros(ndirs, 1);
  min_j               =   1;
  min_cost            =   Inf;

  for j=1:ndirs
    disp(['Direction index: ', num2str(j), ', d = (', ...
         num2str(pattern_basis(1, j)), ', ', num2str(pattern_basis(2, j)), ...
         ')']);
    scalar_cost_func = @(a) cost_func(x_k + a * pattern_basis(:, j));
    disp('Starting line search for step size...');
    [alphas(j), frange, lsiters, lsconv] = line_search_func( ...
                                             scalar_cost_func, search_range, ...
                                             line_search_eps, line_search_iters);
    disp(['Optimal step size ', num2str(alphas(j)), ' found in ', ...
          num2str(lsiters), ' steps.']);
    if lsconv
      disp('Line search converged.');
    else
      disp('WARNING: line search did not converged.');
    end
    disp('Line search ended.');

    cost_j = scalar_cost_func(alphas(j))
    if cost_j < min_cost
      disp('Cost of current direction is less than current minimum');
      min_cost = cost_j
      min_j = j
    end
  end

  E(iter+1)           =   min_cost;
  disp(['Moving in direction: ', num2str(min_j), ', d = (', ...
       num2str(pattern_basis(1, min_j)), ', ', ...
       num2str(pattern_basis(2, min_j)), ')']);
  disp(['With step size: ', num2str(alphas(min_j))]);
  x_k                 =   x_k + alphas(min_j) * pattern_basis(:, min_j)
  points(iter+1, :)   =   x_k;

  disp('Checking for convergence...');
  disp('Is difference in cost < tolerance ?');
  disp(['Is ', num2str(abs(prev_cost - min_cost)), ' < ', ...
       num2str(line_search_eps), ' ?']);
  if abs(prev_cost - min_cost) < line_search_eps
    disp('Yes, done!');
    converged = true;
    break;
  else
    disp('No, keep going');
  end
  
  search_range(2)   =   alphas(min_j)
  prev_cost         =   min_cost

  disp('End iteration');
  disp('---------------------------------------------');
  disp(' ');
end

disp('Pattern search complete');
toc();

iters   =   iter
x       =   x_k

if plot_error_and_path
  disp('Diagnostic plotting');
  plot(linspace(0, iters, iters+1), E(1:iters+1));
  title('E vs. iteration');
  figure();
  scatter(points(:,1), points(:,2), linspace(250, 25, iters+1));
  title('Path taken by search');
else
  disp('Opted not to draw plots.');
end

end
