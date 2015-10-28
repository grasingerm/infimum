f = zeros(15, 1);
f(1) = 1;
f(2) = -1;
f(7) = 1;

A = [   1   -1  1   -1  0   0   0   1   0   0   0   0   0   0   0;
        -1  1   1   -1  0   0   0   0   1   0   0   0   0   0   0;
        -1  1   -1  1   0   0   0   0   0   1   0   0   0   0   0;
        1   -1  -1  1   0   0   0   0   0   0   1   0   0   0   0;
        -1  1  0    0   1   -1  0   0   0   0   0   1   0   0   0;
        -1  1  0    0   1   -1  0   0   0   0   0   0   -1  0   0;
        0   0   -1  1   1   -1  1   0   0   0   0   0   0   -1  0;
        0   0   1   -1  -1  1   1   0   0   0   0   0   0   0   -1];
    
b = [8; 2; 6; 12; 9; 0; 0; 0];
LB = zeros(1, 15);
UB = zeros(1, 15);
UB(1:15) = Inf;

[x, fval, exitflag] = linprog(f, [], [], A, b, LB, UB)

x1 = x(1)-x(2); % x1 = u1 - v1
x2 = x(3)-x(4);
x3 = x(5)-x(6);
x4 = x(7);

assert(abs(x1 - 3) + abs(x2 + 2) <= 7 + 1e-6, ...
       'first constraint failed');
assert(sqrt(x3 - x1) <= 3 + 1e-6, ...
       'second constraint failed');
assert(abs(x4 - abs(x2 - x3)) < 1e-6, ...
       'x4 does not equal |x2 - x3|');

disp(['x1 = u1 - v1 = ', num2str(x1)]);
disp(['x2 = u2 - v2 = ', num2str(x2)]);
disp(['x3 = u3 - v3 = ', num2str(x3)]);
disp(['x4 = |x2 - x3| = ', num2str(x4)]);
disp(['cost = x1 + |x2 - x3| = ', num2str(x1 + abs(x2 - x3))]);
disp(['|x1 - 3| + |x2 + 2| = ', num2str(abs(x1 - 3) + abs(x2 + 2)), ' <= 7']);
disp(['sqrt(x3 - x1) = ', num2str(sqrt(x3 - x1)), ' <= 3']);
disp(['x4 = |x2 - x3| => ', num2str(x4), ' = ', num2str(abs(x2 - x3))]);