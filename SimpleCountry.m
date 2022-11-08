clc; clear; close all

%% Defining the Coast

% Coefficients of polynomial that define the coastline have been
% predetermined (totally arbitrary, but still predetermined)
coastCoeff = load("coastPolyCoeffs.mat");
alphaStar = flipud(coastCoeff.alphaStar);

%The 5th-order polynomial that will define our coast:
coast_line = @(x) polyval(alphaStar, x);

upper_bound = 15;
lower_bound = 0;
right_bound = 15;

x_bounds = [0 right_bound];
x_bounds = max(x_bounds, fsolve((@(x) (coast_line(x) - upper_bound)),0));
x_bounds = min(x_bounds, fsolve((@(x) (coast_line(x) - lower_bound)),0));

fplot(coast_line, x_bounds,'g');
hold on

%% Defining the borders of the country (just straight lines)

%Define upper border as straight line:
x1 = linspace(x_bounds(1), right_bound,100);
y1 = upper_bound.*ones(length(x1));
plot(x1,y1,'g','HandleVisibility','off')

%Define lower border as straight line:
x2 = linspace(x_bounds(2),right_bound ,100);
y2 = lower_bound.*ones(length(x2));
plot(x2,y2,'g','HandleVisibility','off')

%Define right side boarder as straight line:
xv = right_bound.*ones(length(x));
yv = linspace(lower_bound, upper_bound,length(xv));
plot(xv,yv,'g','HandleVisibility','off')


%% Plot some randomly selected population centers:
popCenters = [4.0783    4.0816;
              1.5899   12.2449;
             11.4516   10.8455;];
populations = [1000, 500, 800];
scatter(popCenters(:,1),popCenters(:,2),populations/10,'b*')


%% Add some titles and labels
legend("Borders","Population Center")
title("Fictional Country")
xlabel("''Longitude''")
ylabel("''Latitude''")
axis([-5 20 -5 20]) 
axis equal
