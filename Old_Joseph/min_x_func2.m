function min_val = min_x_func2(x0,y0,dd_handle, dd2_handle, func)

syms x

derivative = @(x) dd_handle(x,x0, y0);

plot(derivative(0:0.1:6))
roots = double(solve(derivative,x));

roots(imag(roots)~=0) = [];
min_max = dd2_handle(roots,x0, y0);

min_vals = roots(~min_max);

[~,idx] = min(func(min_vals,x0,y0));
min_val = min_vals(idx);

end