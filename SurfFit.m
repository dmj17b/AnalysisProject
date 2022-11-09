clc
clear all
close all

cost = load("costMap.mat");
costMap = cost.costMap;

surf(costMap)

x = linspace(0,20,100);
y = linspace(0,20,100);

for i = 1:length(x)
    Phi(i,:) = [1 1 x(i) y(i) x(i)^2 y(i)^2];
end

alphaStar = Phi'*Phi \ (Phi'*costMap);
