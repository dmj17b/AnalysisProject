clc
clear all
close all

%% Defining the "country"

x = 0:0.1:20;

figure();



coastPoints = load("coastPoints.mat")
X = coastPoints.points(:,1);
Y = coastPoints.points(:,2);

plot(X,Y,'b*')

axis([0 20 -20 20]) 

for i = 1:length(X)
    Phi(i,:) = [1 X(i) X(i).^2 X(i).^3 X(i).^4 X(i).^5];
end

alphaStar = Phi'*Phi \ (Phi'*Y)

fx = alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

hold on

plot(x,fx)