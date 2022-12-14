function plant_loc = PlanCluster(cities, coast_points, close_coast)
% Plant_loc = [x,y] coordinates of desired desalination plant
% cities = cities to plan for [lat, long]
% coast_direction = LRUP coastal direction [0 1 2 3]
% coast_points = [long, lat] of full coast

max_dist = 5;
func_order = 6;
%% Plot the cities

filt = vecnorm(close_coast - coast_points,2,2) > max_dist;
coast_points(filt,:) = [];

%% Rotate the Polynomial and Fit
coeffs = polyfit(coast_points(:,1), coast_points(:,2),1);

rot = -atan2(coeffs(1),1);

mean_lon = mean(coast_points(:,1));
mean_lat = mean(coast_points(:,2));

rot_coast = ([cos(rot) -sin(rot); sin(rot) cos(rot)]*(coast_points' - [mean_lon;mean_lat]))' + [mean_lon mean_lat];
%geoplot(rot_coast(:,2), rot_coast(:,1),'-k','Linewidth', 2);

coeffs = polyfit(rot_coast(:,1), rot_coast(:,2), func_order);
lat_est = polyval(coeffs, rot_coast(:,1));

fitted_coast = ([cos(-rot) -sin(-rot); sin(-rot) cos(-rot)]*([rot_coast(:,1), lat_est]' - [mean_lon; mean_lat]))' + [mean_lon mean_lat];

geoplot(fitted_coast(:,2),fitted_coast(:,1), 'LineWidth',2, 'color', 'red')

%% Find Best Location

%figure
%geobasemap colorterrain
%hold on
%rot_coast = ([cos(rot) -sin(rot); sin(rot) cos(rot)]*(coast_points' - [mean_lon;mean_lat]))' + [mean_lon mean_lat];
%geoplot(rot_coast(:,2), rot_coast(:,1), 'LineWidth',2, 'color', 'red')

syms x y l1

coast_line = 0;
for i = 1:func_order+1
    coast_line = coast_line + coeffs(i)*x^(func_order+1-i);
end

cities_rot = ([cos(rot) -sin(rot); sin(rot) cos(rot)]*(cities(:,2:-1:1)'- [mean_lon; mean_lat]))' + [mean_lon mean_lat];

%geoscatter(cities_rot(:,2), cities_rot(:,1),100,'red','Marker','.');

D2P_Full = 0;

for i = 1:size(cities(:,3),1)
    D2P_Full = D2P_Full + cities(i,3)*sqrt((x - cities_rot(i,1)).^2 + (y - cities_rot(i,2)).^2);
end

H = D2P_Full + l1*(y-coast_line);
dHdx = diff(H,x) == 0;
dHdy = diff(H,y) == 0;
dHdl1 = diff(H,l1) == 0;

sol = solve(dHdx, dHdy,dHdl1);

l_idx = double(imag(sol.l1) ~= 0);
xy_idx = or(double(imag(sol.x) ~= 0), double(imag(sol.y) ~= 0));
bad_idx = or(l_idx, xy_idx);
sol.x(bad_idx) = [];
sol.y(bad_idx) = [];

%disp(sol.x(1))
%disp(sol.y(1))
%plant_loc = [double(sol.x(1)) double(sol.y(1))];
plant_loc = double(([cos(-rot) -sin(-rot); sin(-rot) cos(-rot)]*([sol.x(1); sol.y(1)] - [mean_lon; mean_lat]))' + [mean_lon mean_lat]);
plant_loc = fliplr(plant_loc);
%geoscatter(plant_loc(1), plant_loc(2),100,'dg')
%drawnow
%}
end