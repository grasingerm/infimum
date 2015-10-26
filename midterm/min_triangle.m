function [x, d1, d2, d3, area] = min_triangle(filename, R1, C1, do_plot)
%MIN_TRIANGLE Finds min equilateral triangle that encloses a set of points.
%
%   [x, d1, d2, d3, area] = MIN_TRIANGLE(filename) finds the smallest
%   equilateral triangle that encloses the set of points contained in the csv
%   file given by filename. Plots points and resulting triangle.
%
%   [x, d1, d2, d3, area] = MIN_TRIANGLE(filename, R1, C1) finds the smallest
%   equilateral triangle that encloses the set of points contained in the csv
%   file given by filename. Skips first R1 rows and C1 columns of csv. Plots
%   points and resulting triangle.
%
%   [x, d1, d2, d3, area] = MIN_TRIANGLE(filename, R1, C1, do_plot) finds the 
%   smallest equilateral triangle that encloses the set of points contained in 
%   the csv file given by filename. Skips first R1 rows and C1 columns of csv.
%   If do_plot is true, plots points and resulting triangle, else no plot is
%   created.

  validateattributes(filename, {'char','cell'}, {'nonempty'});

  if nargin < 3
    R1 = 0;
    C1 = 0;
  end
  
  if nargin < 4
    do_plot = true;
  end

  % equations of lines
  a = [0 1; sqrt(3)/2 1/2; -sqrt(3)/2 1/2];

  % read points in from csv file
  X = csvread(filename, R1, C1);
 
  % constraints: A * x \leq b
  % d1, d2, d3 = u1 - v1, u2 - v2, u3 - v3
  num_points = size(X, 1);
  A = zeros(3*num_points, 3*num_points+6);
  b = zeros(3*num_points, 1);
  LB = zeros(1, 3*num_points+6);
  UB(1, 1:3*num_points+6) = Inf;

  for i=1:num_points
    A(3*i-2,    1:2)   = [1 -1];
    A(3*i-1,    3:4)   = [1 -1];
    A(3*i,      5:6)   = [1 -1];
    A(3*i-2,    3*i+4) =  1;
    A(3*i-1,    3*i+5) = -1;
    A(3*i,      3*i+6) = -1;
    b(3*i-2:3*i)     = a * transpose(X(i,:));
  end

  % x = [d1; d2; d3]  = [u1; v1; u2; v2; u3; v3];
  % f = [-1; 1; 1]    = [-1; 1; 1; -1; 1; -1];
  f = zeros(3*num_points + 6, 1);
  f(1:6) = [-1; 1; 1; -1; 1; -1];
  x = linprog(f, [], [], A, b, LB, UB);

  d1 = x(1) - x(2);
  d2 = x(3) - x(4);
  d3 = x(5) - x(6);

  area = sqrt(3) / 3 * (-d1 + d2 + d3)^2;
  
  if do_plot
    scatter(X(:,1), X(:,2))
    hold on
    plot_triangle(d1, d2, d3);
  end
  
end
