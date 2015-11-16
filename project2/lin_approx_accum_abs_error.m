function error = lin_approx_accum_abs_error(X, a)
%LIN_APPROX_ACCUM_ABS_ERROR Accumulated absolute error for line of fit
%
%   error = LIN_APPROX_ACCUM_ABS_ERROR(X, a)
%   Sum of absolute values of differences between a linear approximation
%   given by a(1)*x + a(2) and actual data points in two dimensions

error = 0;
rows = size(X, 1);
for i=1:rows
    error = error + abs(X(i,2) - a(1)*X(i,1) - a(2));
end

end
