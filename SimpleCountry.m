clc; clear; close all

%% Defining the Coast

% Coefficients of polynomial that define the coastline have been
% predetermined (totally arbitrary, but still predetermined)
coastCoeff = load("coastPolyCoeffs.mat");
alphaStar = coastCoeff.alphaStar;

%Some linearly spaced x values
x = linspace(0.55,5.9625,100);

%The 5th-order polynomial that will define our coast:
fx = alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

coast_line = @(x) alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

%coast_line = @(x) -x+15

upper_bound = 15;
lower_bound = 0;
right_bound = 15;

options = optimset('Display','off');
x_bounds = [0 right_bound];
x_bounds = max(x_bounds, fsolve((@(x) (coast_line(x) - upper_bound)),0,options));
x_bounds = min(x_bounds, fsolve((@(x) (coast_line(x) - lower_bound)),0, options));

plot(x, fx,'g');
hold on

%%% Defining the borders of the country (just straight lines)

%Define upper border as straight line:
x1 = linspace(x_bounds(1), right_bound,2);
y1 = upper_bound.*ones(length(x1));
plot(x1,y1,'g','HandleVisibility','off')

%Define lower border as straight line:
x2 = linspace(x_bounds(2),right_bound ,2);
y2 = lower_bound.*ones(length(x2));
plot(x2,y2,'g','HandleVisibility','off')

%Define right side boarder as straight line:
xv = right_bound.*ones(2,1);
yv = linspace(lower_bound, upper_bound,length(xv));
plot(xv,yv,'g','HandleVisibility','off')


%% Plot some randomly selected population centers:
popCenters = [4.0783    4.0816;
              1.5899   12.2449;
             11.4516   10.8455;
             14.2416    2.1937;];
plot(popCenters(:,1),popCenters(:,2),'b*')

%% Add some titles and labels
legend("Borders","Population Center")
title("Fictional Country")
xlabel("''Longitude''")
ylabel("''Latitude''")
axis([0 right_bound lower_bound upper_bound]) 
axis equal

%% Distance to coastline

%Create a meshgrid of lat/lon coordinates
LAT = linspace(0,15,100);
LON = linspace(0,15,100);
[LAT,LON] = meshgrid(LAT,LON);

%Create distance variables:
D2Coast = zeros(length(x),1);    %At a given point, this is the distance to every point 
                           %on the function fx
minD2Coast = zeros(size(LAT));   %Minimum distance from each x,y coordinate to the line fx

for i = 1:length(LON)
    for j = 1:length(LAT)
        for n = 1:length(x)
            D2Coast(n) = sqrt((LON(i,j)-x(n))^2 + (LAT(i,j)-fx(n))^2);    %Calculate distance from coordinates to point on the line
        end
        minD2Coast(i,j) = unique(min(D2Coast));
    end
end
%Plot
figure(2)
surfc(LON,LAT,minD2Coast)
xlabel("LON")
ylabel("LAT")
zlabel("Distance Squared")


%% Distance to cities

D2City1 = zeros(size(LAT));
D2City2 = zeros(size(LAT));
D2City3 = zeros(size(LAT));
D2City4 = zeros(size(LAT));

%LAT/LON coordinates of cities
popCenters = [4.0783    4.0816;
              1.5899   12.2449;
             11.4516   10.8455;
             14.2416    2.1937;];

for i = 1:length(LON)
    for j = 1 : length(LAT)
        D2City1(i,j) = sqrt((LON(i,j)-popCenters(1,1))^2 + (LAT(i,j)-popCenters(1,2))^2);
        D2City2(i,j) = sqrt((LON(i,j)-popCenters(2,1))^2 + (LAT(i,j)-popCenters(2,2))^2);
        D2City3(i,j) = sqrt((LON(i,j)-popCenters(3,1))^2 + (LAT(i,j)-popCenters(3,2))^2);
        D2City4(i,j) = sqrt((LON(i,j)-popCenters(4,1))^2 + (LAT(i,j)-popCenters(4,2))^2);

    end
end
d2pop = D2City1 + D2City2 + D2City3 + D2City4;

figure;
surf(LON,LAT,10.*d2pop);

%% Putting them together 
figure;
surf(LON,LAT,d2pop+minD2Coast)
