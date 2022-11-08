function min_val = min_x_func_2(x,y,handle, bounds, func)

zeros_func = @(x_new) handle(x_new,x,y);
tmp_bounds = bounds;

search_space = tmp_bounds(1):0.001:tmp_bounds(2);

zero_search = zeros_func(search_space);
[~,idx] = find(abs(diff(zero_search)) < 0.1,length(search_space));
min_v = search_space(idx);

[~, idx] = min(sqrt((min_v - x).^2 + (func(min_v) - y).^2));
min_val = min_v(idx);
end