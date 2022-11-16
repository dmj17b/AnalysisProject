function plant_loc = PlanCluster_Discrete(cities, coast_points, close_coast)
% Plant_loc = [x,y] coordinates of desired desalination plant
% cities = cities to plan for [lat, long]
% coast_direction = LRUP coastal direction [0 1 2 3]
% coast_points = [long, lat] of full coast

max_dist = 7.5;
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
coeffs = polyfit(rot_coast(:,1), rot_coast(:,2), func_order);
lat_est = polyval(coeffs, rot_coast(:,1));
fitted_coast = ([cos(-rot) -sin(-rot); sin(-rot) cos(-rot)]*([rot_coast(:,1), lat_est]' - [mean_lon; mean_lat]))' + [mean_lon mean_lat];

geoplot(fitted_coast(:,2),fitted_coast(:,1), 'LineWidth',2, 'color', 'red')

%% Find Best Location

x = interp1(linspace(0,1,length(fitted_coast(:,1))),fitted_coast(:,1),linspace(0,1,1000));
y = interp1(linspace(0,1,length(fitted_coast(:,2))),fitted_coast(:,2),linspace(0,1,1000));

cities_rot = ([cos(rot) -sin(rot); sin(rot) cos(rot)]*(cities(:,2:-1:1)'- [mean_lon; mean_lat]))' + [mean_lon mean_lat];

D2P_Full = 0;
for i = 1:size(cities,1)
    D2P_Full = D2P_Full + cities(i,3)*sqrt((x - cities_rot(i,1)).^2 + (y - cities_rot(i,2)).^2);
end

[~, idxs] = min(D2P_Full);
sol.x = x(idxs);
sol.y = y(idxs);

plant_loc = [double(sol.x(1)) double(sol.y(1))];
plant_loc = fliplr(plant_loc);
end