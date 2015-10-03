% change algorithm to simplex method
options = optimoptions('linprog','Algorithm','simplex');

% faa, fab, fag, fad, fbb, fbg, fbd, fgg, fgd, fdd, ba, bb, bg, bd
%   1,   2,   3,   4,   5,   6,   7,   8,   9,  10, 11, 12, 13, 14

f = [1; 2; 5; 10; 2; 5; 10; 5; 10; 10; 1; 2; 5; 10];

Aeq = [
        1   1   1   1   1   1   1   1   1   1   0   0   0   0;
        1   1   1   1   0   0   0   0   0   0   -1  0   0   0;
        0   1   0   0   1   1   1   0   0   0   0   -1  0   0;
        0   0   1   0   0   1   0   1   1   0   0   0   -1  0;
        0   0   0   1   0   0   1   0   1   1   0   0   0   -1;
        0   0   0   0   0   0   0   0   0   0   1   1   1   1
      ];

beq = [3   1   1   1   1   2];

num_vars = size(Aeq, 2);
LB = zeros(num_vars);
UB(1:num_vars) = Inf;

[x, fval, exitflag, output] = linprog(f, [], [], Aeq, beq, LB, UB);

% faa, fab, fag, fad, fbb, fbg, fbd, fgg, fgd, fdd, ba, bb, bg, bd
%   1,   2,   3,   4,   5,   6,   7,   8,   9,  10, 11, 12, 13, 14
if (x(1) > 1e-6)
    fprintf('%.0f = the number of forward trips alpha makes alone\n', x(1));
end
if (x(2) > 1e-6)
    fprintf('%.0f = the number of forward trips alpha makes with beta\n', x(2));
end
if (x(3) > 1e-6)
    fprintf('%.0f = the number of forward trips alpha makes with gamma\n', x(3));
end
if (x(4) > 1e-6)
    fprintf('%.0f = the number of forward trips alpha makes with delta\n', x(4));
end
if (x(5) > 1e-6)
    fprintf('%.0f = the number of forward trips beta makes alone\n', x(5));
end
if (x(6) > 1e-6)
    fprintf('%.0f = the number of forward trips beta makes with gamma\n', x(6));
end
if (x(7) > 1e-6)
    fprintf('%.0f = the number of forward trips beta makes with delta\n', x(7));
end
if (x(8) > 1e-6)
    fprintf('%.0f = the number of forward trips gamma makes alone\n', x(8));
end
if (x(9) > 1e-6)
    fprintf('%.0f = the number of forward trips gamma makes with delta\n', x(9));
end
if (x(10) > 1e-6)
    fprintf('%.0f = the number of forward trips delta makes alone\n', x(10));
end
if (x(11) > 1e-6)
    fprintf('%.0f = the number of backward trips alpha makes\n', x(11));
end
if (x(12) > 1e-6)
    fprintf('%.0f = the number of backward trips beta makes\n', x(12));
end
if (x(13) > 1e-6)
    fprintf('%.0f = the number of backward trips gamma makes\n', x(13));
end
if (x(14) > 1e-6)
    fprintf('%.0f = the number of backward trips delta makes\n', x(14));
end

fprintf('The total time taken for everyone to cross = %.0f\n', f'*x);