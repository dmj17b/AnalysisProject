clc
clear all
close all

%% Defining the Coast

% Coefficients of polynomial that define the coastline have been
% predetermined (totally arbitrary, but still predetermined)
coastCoeff = load("coastPolyCoeffs.mat")
alphaStar = coastCoeff.alphaStar;

%Some linearly spaced x values
x = linspace(0.55,5.9625,1000);

%The 5th-order polynomial that will define our coast:
fx = alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

plot(x,fx,'g');
hold on

%% Defining the borders of the country (just straight lines)

%Define upper border as straight line:
x1 = linspace(0.55,15,100);
y1 = 15.*ones(length(x1));

%Define lower border as straight line:
x2 = linspace(5.9,15,100);
y2 = 0.*ones(length(x2));

%Define right side boarder as straight line:
xv = 15.*ones(length(x));
yv = linspace(0,15,length(xv));

plot(x1,y1,'g','HandleVisibility','off')
plot(x2,y2,'g','HandleVisibility','off')
plot(xv,yv,'g','HandleVisibility','off')


%% Plot some randomly determined population centers:
popCenters = [4.0783    4.0816;
              1.5899   12.2449;
             11.4516   10.8455;];
plot(popCenters(:,1),popCenters(:,2),'b*')

%% Add some titles and labels
legend("Borders","Population Center")
title("Fictional Country")
xlabel("''Longitude''")
ylabel("''Latitude''")
axis([-5 20 -5 20]) 
axis equal
