function min_val = min_x_func_2(x,y,handle, bounds, func)

x_points = linspace(bounds(1), bounds(2),100);
zeros_func = @(x_new) handle(x_new,x,y);

%zeros_func_eval = zeros_func(x_points);

my_spline = spline(x_points,zeros_func(x_points));
min_x = fnzeros(my_spline);
min_x = min_x(1,:);
min_x(imag(min_x) ~= 0) = [];
min_val =[];
if(length(min_x) >= 1)
    [~, idx] = min(sqrt((min_x - x).^2 + (func(min_x) - y).^2));
    min_val = min_x(idx);
    min_val = max(min_val, bounds(1));
    min_val = min(min_val, bounds(2));
end

if(isempty(min_val))
    min_val = bounds(2);
end

