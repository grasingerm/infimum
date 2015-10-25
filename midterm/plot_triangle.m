function cost = plot_triangle(d1, d2, d3)

xa = 2*sqrt(3)/3 * (-0.5 * d1 + d2);
xb = 2*sqrt(3)/3 * (0.5 * d1 - d3);

x1 = min(xa, xb);
x2 = max(xa, xb);

cost = -d1 + d2 + d3;

xs = linspace(x1, x2, 500);
ys_d1(1:500) = d1;
if cost >= 0
  xs_1 = xs(1:250);
  xs_2 = xs(251:500);
else
  xs_2 = xs(1:250);
  xs_1 = xs(251:500);
end
ys_d2 = 2 * d2 - sqrt(3) * xs_2;
ys_d3 = 2 * d3 + sqrt(3) * xs_1;


plot(xs, ys_d1, xs_2, ys_d2, xs_1, ys_d3)

end

