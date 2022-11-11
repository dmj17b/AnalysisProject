function min_val = min_x_func(x,y,handle, bounds, func)

zeros_func = @(x_new) handle(x_new,x,y);
tmp_bounds = bounds;

search_space = tmp_bounds(1):0.001:tmp_bounds(2);

a = ones(1,1,length(search_space));
a(1,1,:) = search_space;

zero_search = zeros_func(a);
%[~,idx] = find(diff(zero_search,1,3) < 0.1,length(search_space));
[~, idx] = maxk(diff(zero_search,1,3) < 0.1,length(search_space),3);
min_v = search_space(idx(1,1,:));

b = ones(1,1,length(min_v));
b(1,1,:) = min_v;

[~, idx] = min(sqrt((b - x).^2 + (func(b) - y).^2), [], 3);
min_val = min_v(idx);
end