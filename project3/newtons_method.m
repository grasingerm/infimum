function [x, iters, converged] = newtons_method(cost_func,             ...
                                                cost_gradient,         ...
                                                cost_inv_hessian,      ...
                                                line_search_func,      ...
                                                newtons_method_eps,    ...
                                                newtons_method_iters,  ...
                                                line_search_eps,       ...
                                                line_search_iters,     ...
                                                line_search_init_range,...
                                                init_guess,            ...
                                                plot_error_and_path)

if nargin < 8
  init_guess = [0; 0];
end

if nargin < 9
  plot_error_and_path = false;
end

search_range    =   line_search_init_range;
x_k             =   init_guess;
prev_cost       =   cost_func(x_k);
converged       =   false;
E(1)            =   prev_cost;
points(1,:)     =   x_k;

for iter=1:newtons_method_iters

  d     =   -cost_inv_hessian(x_k) * cost_gradient(x_k);
  alpha =   line_search_func(@(a) cost_func(x_k + a * d),           ...
                             search_range,                          ...
                             line_search_eps, line_search_iters);
  x_k   =   x_k + alpha * d;

  cost_k = cost_func(x_k);
  E(iter+1)           =   cost_k;
  points(iter+1, :)   =   x_k;

  if abs(prev_cost - cost_k) < steepest_descent_eps
    converged = true;
    break;
  end

  prev_cost           =   cost_k;
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
