function min_val = min_x_func(x,y,sym_func, bounds)
syms x0 y0
sols = subs(sym_func, [x0 y0], [x,y]).x;
sols = double(sols);
sols(imag(sols) ~= 0) = [];
%fprintf("X: %0.2f\n", x)
[~,idx] = min(abs(sols-x));
min_val = sols(idx);
min_val = max(min_val, bounds(1));
min_val = min(min_val, bounds(2));
