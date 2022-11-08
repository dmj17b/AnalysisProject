clc; clear; close all

%% Region Data
upper_bound = 1000;
lower_bound = 0;
right_bound = 1000;
coast_line = @(x) -5*x + 0.01*x.^2 - 0.000007*x.^3 + 1000;

locations = [200, 900
             500, 400 
             800, 800
             800, 200];

populations = [1000, 500, 1000, 700];

x_bounds = [0 right_bound];
x_bounds = max(x_bounds, fsolve((@(x) (coast_line(x) - upper_bound)),0));
x_bounds = min(x_bounds, fsolve((@(x) (coast_line(x) - lower_bound)),0));

%% Equation Params
local_weight = 1;
coastal_weight = 1;
pipe_K = 1;
gpm_per_head = 1;

%% Cost Function Params
syms x x0 y0
dist_coast = sqrt((x-x0).^2 + (coast_line(x)-y0).^2);
zeros_dist_cost = diff(dist_coast) == 0;
min_x = solve(zeros_dist_cost,x, 'ReturnConditions',true);

dist_coast_func_helper = @(x,y,x0) sqrt((x0-x).^2 + (coast_line(x0)-y).^2);
dist_coast_func = @(x,y) dist_coast_func_helper(x,y,min_x_func(x,y,min_x,x_bounds));

%{
for i = 1:length(populations)
    tmp_func = @(x,y) pipe_K*gpm_per_head*populations(i)*sqrt(x.^2 + y.^2);
    cost_plant = @(x,y) cost_plant(x,y) + tmp_func(x,y);
end
%}

%% Country Map
scaling_factor = 10;

figure
hold on
xline(right_bound)
yline(upper_bound)
yline(lower_bound)
fplot(coast_line,'b')
grid on
axis([-10 1010 -10 1010])
scatter(locations(:,1), locations(:,2), populations/scaling_factor, 'bx')

%% Cost Functions
x_points = 20;
y_points = 20;
x = linspace(0,right_bound,x_points);
y = linspace(lower_bound,upper_bound,y_points);
[X,Y] = meshgrid(x,y);
coast_cost = zeros(x_points, y_points);

for i = 1:x_points
    for j = 1:y_points
        coast_cost(j,i) = dist_coast_func(x(i), y(j));
        fprintf("ij: (%d, %d), xy:(%0.2f, %0.2f), Dist: %f\n", i,j,x(i),y(j),coast_cost(j,i));
    end
end

figure
hold on

surf(X,Y,coast_cost)
shading interp
xlim([-10 1010])
ylim([-10 1010])

