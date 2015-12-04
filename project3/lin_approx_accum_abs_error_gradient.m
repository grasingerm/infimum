function grad = lin_approx_accum_abs_error_gradient(X, a)
%LIN_APPROX_ACCUM_ABS_ERROR_GRADIENT Gradient of linear approximation cost
%
%   grad = LIN_APPROX_ACCUM_ABS_ERROR_GRADIENT(X, a)
%   Gradient of cost function that is calculated by summing absolute values
%   of differences between a linear approximation given by a(1)*x + a(2) 
%   and actual data points in two dimensions.

grad = zeros(2, 1);

rows = size(X, 1);
for i=1:rows
  error = X(i,2) - a(1)*X(i,1) - a(2);
  edir = abs(error) / error;
  grad(1) = grad(1) - X(i,1) * edir;
  grad(2) = grad(2) - edir;
end

end