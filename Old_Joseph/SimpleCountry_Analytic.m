clc; clear; close all

%% Defining the Coast

% Coefficients of polynomial that define the coastline have been
% predetermined (totally arbitrary, but still predetermined)
coastCoeff = load("coastPolyCoeffs.mat");
alphaStar = coastCoeff.alphaStar;

%The 5th-order polynomial that will define our coast:
coast_line = @(x) alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

%coast_line = @(x) -x+15

upper_bound = 15;
lower_bound = 0;
right_bound = 15;

options = optimset('Display','off');
x_bounds = [0 right_bound];
x_bounds = max(x_bounds, fsolve((@(x) (coast_line(x) - upper_bound)),0,options));
x_bounds = min(x_bounds, fsolve((@(x) (coast_line(x) - lower_bound)),right_bound, options));

fplot(coast_line, x_bounds,'k');
hold on

%%% Defining the borders of the country (just straight lines)

%Define upper border as straight line:
x1 = linspace(x_bounds(1), right_bound,2);
y1 = upper_bound.*ones(length(x1));
plot(x1,y1,'k','HandleVisibility','off')

%Define lower border as straight line:
x2 = linspace(x_bounds(2),right_bound ,2);
y2 = lower_bound.*ones(length(x2));
plot(x2,y2,'k','HandleVisibility','off')

%Define right side boarder as straight line:
xv = right_bound.*ones(2,1);
yv = linspace(lower_bound, upper_bound,length(xv));
plot(xv,yv,'k','HandleVisibility','off')


%% Plot some randomly selected population centers:
popCenters = [4.0783    4.0816;
              1.5899   12.2449;
              11.4516   10.8455;
             14.2416    2.1937;];

populations = [1000, 500, 800, 500];
scatter(popCenters(:,1),popCenters(:,2),populations/10,'b*')

%% Add some titles and labels
legend("Borders","Population Center")
title("Fictional Country")
xlabel("''Longitude''")
ylabel("''Latitude''")
axis([0 right_bound lower_bound upper_bound]) 
axis equal

%% Equation Params
local_weight = 1;
coastal_weight = 1;
pipe_K = 1;
gpm_per_head = 1;

%% Distance To Coast
syms x x0 y0
dist_coast = sqrt((x-x0).^2 + (coast_line(x)-y0).^2);
zeros_dist_cost = diff(dist_coast) == 0;
root_func = matlabFunction(diff(dist_coast));
min_x = solve(zeros_dist_cost,x, 'ReturnConditions',true);

dist_coast_func_helper = @(x,y,x0) sqrt((x0-x).^2 + (coast_line(x0)-y).^2);
dist_coast_func = @(x,y) dist_coast_func_helper(x,y,min_x_func(x,y,root_func,x_bounds,coast_line));
%% Distance To Coast

x_points = 100;
y_points = 100;
x = linspace(0,right_bound,x_points);
y = linspace(lower_bound,upper_bound,y_points);
[X,Y] = meshgrid(x,y);

%{
coast_cost = dist_coast_func(X,Y);

figure
hold on

surf(X,Y,coast_cost)
shading interp
xlim([0 right_bound])
ylim([lower_bound upper_bound])
title("Distance To Coast - Analytic (Slow)")
xlabel("''Longitude''")
ylabel("''Latitude''")
%}

%% Distance to Population Centers

D2P = cell(size(popCenters,1),1);

for i = 1:size(popCenters,1)
    D2P{i} = @(x,y) populations(i)*sqrt((x - popCenters(i,1)).^2 + (y - popCenters(i,2)).^2);
    %figure
    %surf(X,Y,D2P{i}(X,Y); 
    %shading interp
    %view(0,90)
end

D2P_Full = @(x,y) 0;
for i = 1:size(popCenters,1)
    D2P_Full = (@(x,y) D2P_Full(x,y) +  D2P{i}(x,y));
end

D2P_Full = (@(x,y) D2P_Full(x,y) + sum(populations)*dist_coast_func(x, y));
%figure
Z = D2P_Full(X,Y);
minMatrix = min(Z(:));
[row,col] = find(Z==minMatrix);

scatter(x(col),y(row),'gd','DisplayName', 'Plant Location')
%surf(X,Y,Z)
%shading interp
%view(0,90)
