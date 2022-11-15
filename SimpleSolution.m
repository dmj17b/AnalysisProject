clc; clear; close all

%% Defining the Coast
coastCoeff = load("coastPolyCoeffs.mat");
alphaStar = coastCoeff.alphaStar;

syms x y l1 l2 s t
coast_line = alphaStar(1,:) + alphaStar(2,:).*x + alphaStar(3,:).*x.^2 + alphaStar(4,:).*x.^3 ...
    + alphaStar(5,:).*x.^4 + alphaStar(6,:).*x.^5;

upper_bound = 15;
lower_bound = 0;
right_bound = 15;

x_bounds = [0 right_bound];

sols = double(solve(coast_line - upper_bound == 0,x));
sols(imag(sols)~=0) = [];
x_bounds = max(x_bounds, max(sols));
sols = double(solve(coast_line - lower_bound == 0,x));
sols(imag(sols)~=0) = [];
x_bounds = min(x_bounds, max(sols));

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

coast_alpha = 0.85;

%% Add some titles and labels
legend("Borders","Population Center")
title("Fictional Country")
xlabel("''Longitude''")
ylabel("''Latitude''")
axis([0 right_bound lower_bound upper_bound]) 
axis equal

%% Distance to Population Centers

D2P = cell(size(popCenters,1),1);

for i = 1:size(popCenters,1)
    D2P{i} = populations(i)*sqrt((x - popCenters(i,1)).^2 + (y - popCenters(i,2)).^2);
end

D2P_Full = 0;
for i = 1:size(popCenters,1)
    D2P_Full = D2P_Full +  D2P{i};
end

H = D2P_Full + l1*(y-coast_line);
dHdx = diff(H,x) == 0;
dHdy = diff(H,y) == 0;
dHdl1 = diff(H,l1) == 0;

sol = vpasolve(dHdx, dHdy,dHdl1);
for i = 1:length(sol.x)
    fprintf("Optimal Solutions: (%0.2f, %0.2f), Score: %0.2f\n", [sol.x(i), sol.y(i)], double(subs(D2P_Full, [x y], [sol.x(i) sol.y(i)])))
end

l_idx = double(imag(sol.l1) ~= 0);
xy_idx = or(double(imag(sol.x) ~= 0), double(imag(sol.y) ~= 0));
bad_idx = or(l_idx, xy_idx);
sol.x(bad_idx) = [];
sol.y(bad_idx) = [];

scatter(sol.x(1),sol.y(1),'gd','DisplayName', 'Optimal Plant Location')
drawnow