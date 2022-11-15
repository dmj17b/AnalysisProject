function plant_loc = PlanCluster(cities, coast_direction, coast_points, close_coast)
% Plant_loc = [x,y] coordinates of desired desalination plant
% cities = cities to plan for [lat, long]
% coast_direction = LRUP coastal direction [0 1 2 3]
% coast_points = [long, lat] of full coast

figure
geobasemap colorterrain
hold on

plant_loc = [0 0];
max_dist = 5;
%% Plot the cities

geoscatter(cities(:,1), cities(:,2),100,'.k')
geolimits([min(cities(:,1)) max(cities(:,1))],[min(cities(:,2)) max(cities(:,2))])

min_lon = min(cities(:,2));
max_lon = max(cities(:,2));
min_lat = min(cities(:,1));
max_lat = max(cities(:,1));


filt = vecnorm(close_coast - coast_points,2,2) > max_dist;
coast_points(filt,:) = [];

if coast_direction == 0 || coast_direction == 1
    %
else
    %
end


coeffs = polyfit(coast_points(:,1), coast_points(:,2),1);

rot = -atan2(coeffs(1),1);

mean_lon = mean(coast_points(:,1));
mean_lat = mean(coast_points(:,2));

rot_coast = ([cos(rot) -sin(rot); sin(rot) cos(rot)]*(coast_points' - [mean_lon;mean_lat]))' + [mean_lon mean_lat];
%geoplot(rot_coast(:,2), rot_coast(:,1),'-k','Linewidth', 2);

coeffs = polyfit(rot_coast(:,1), rot_coast(:,2), 6);
lat_est = polyval(coeffs, rot_coast(:,1));

mean_lat = mean(lat_est);
mean_lon = mean(rot_coast(:,1));

fitted_coast = ([cos(-rot) -sin(-rot); sin(-rot) cos(-rot)]*([rot_coast(:,1), lat_est]' - [mean_lon; mean_lat]))' + [mean_lon mean_lat];

geoplot(fitted_coast(:,2),fitted_coast(:,1), 'LineWidth',2, 'color', 'red')
%disp("Filter by distance to coastal point instead")
%geoplot(coast_points(:,2), coast_points(:,1),'-k','Linewidth', 2);
end