clc
clear all

%Load numerical cost map
cost = load("costMap.mat");
costMap = cost.costMap;

%Load coast 
coast = load("coastPoints.mat");

%% Taking some spaced out points from the coastline

% Coefficients of polynomial that define the coastline have been
% predetermined (totally arbitrary, but still predetermined)
coastCoeff = load("coastPolyCoeffs.mat");
alphaStar = coastCoeff.alphaStar;

%Some linearly spaced x values
coastx = linspace(0.55,5.9625,100);

%The 5th-order polynomial that will define our coast:
coastfx = alphaStar(1,:) + alphaStar(2,:).*coastx + alphaStar(3,:).*coastx.^2 + alphaStar(4,:).*coastx.^3 ...
    + alphaStar(5,:).*coastx.^4 + alphaStar(6,:).*coastx.^5;

%We are going to preselect some linearly spaced points along the coast:
coastPoints = zeros(length(coastfx)/5,2);
iter = 1;
for i = 1:5:size(coastfx,2)
    coastPoints(iter,:) = [coastx(:,i) coastfx(:,i)];
    iter = iter+1;
end


%% Create x,y mesh
N = size(costMap,1);
Nsq = N^2;
x = linspace(0,15,size(costMap,1));
y = linspace(0,15,size(costMap,1));
[X,Y] = meshgrid(x,y);

%% Attempt using radial basis functions:
popCenters = [4.0783    4.0816;
           1.5899   12.2449;
          11.4516   10.8455;
          14.2416    2.1937;];

centers = [popCenters; coastPoints];

s = 5;

xi = [X(5,9) Y(5,9)]';  %Selecting a random xi value for testing
xc = centers(2,:)';     %Selecting a random xc value for testing

Phi = zeros(Nsq,size(centers,1)+1);   %Preallocating Phi (regressor) matrix
costP = zeros(Nsq,1);   %We will also be putting the cost map in a different format

%Cycle through all of the points on a mesh grid:
iter = 1;
for i = 1:size(X,1)
    for j = 1:size(Y,1)
        xi = [X(i,j) Y(i,j)]';   %Just putting point into the correct format
        PhiRow = calcphirow(xi,centers,s);  %Calculating the row for given point
        Phi(iter,:) = PhiRow;             %Add the row to phi
        costP(iter,:) = costMap(i,j);
        iter = iter+1;                      %Move to next row of phi
    end
end


%Calculate least squares fit:
a_star = (Phi'*Phi)\(Phi'*costP);

%Use coefficents to generate the rbf map
costRBF = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(Y,1)
        xi = [X(i,j) Y(i,j)]';
        costRBF(i,j) = (calcphirow(xi,centers,s)*a_star);
    end
end

%Plot the rbf map
figure;
surfc(X,Y,costRBF)

figure;
%Plot the numerically generated cost map
surfc(X,Y,costMap)

