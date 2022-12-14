clc
clear
close all
echo on

cost = load("costMap.mat");
costMap = cost.costMap;

figure
surf(costMap)

x = linspace(0,20,size(costMap,2));
y = linspace(0,20,size(costMap,1));

[X,Y] = meshgrid(x,y);
%{
for i = 1:length(x)
    Phi(i,:) = [1 1 x(i) y(i) x(i)^2 y(i)^2];
end
alphaStar = Phi'*Phi \ (Phi'*costMap);
%}
len = size(costMap,1)*size(costMap,2);
x_vec = X(:);
y_vec = Y(:);
z_vec = costMap(:);


%% From the bottom of this paper ... https://www.sci.utah.edu/~balling/FEtools/doc_files/LeastSquaresFitting.pdf
order = 15;
dim = (order+1)*(order+2)/2;
Phi = zeros(dim);

syms x y z

Q = sym('a',[dim,1]);

idx = 1;
for i = 0:order
    for j = 0:order
        if(i+(order-j) <= order)
            Q(idx) = (x.^i).*(y.^(order-j));
            idx = idx + 1;
        end
    end
end
pretty(Q)
%%
A_func = matlabFunction(Q*Q');
b_func = matlabFunction(z.*Q);

A = zeros(dim);
b = zeros(dim,1);
parfor i = 1:len
    A = A + A_func(x_vec(i),y_vec(i));
    b = b + b_func(x_vec(i),y_vec(i),z_vec(i));
end

P = A\b;

f = matlabFunction(sum(P.*Q));

Z = f(x_vec,y_vec);
Z = reshape(Z, size(costMap));

figure
surf(X,Y,Z)

save Analytic_CostMap f -mat




