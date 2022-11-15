function plant_loc = PlanCluster(cities, coast_direction, coast_points)
% Plant_loc = [x,y] coordinates of desired desalination plant
% cities = cities to plan for [lat, long]
% coast_direction = LRUP coastal direction [0 1 2 3]
% coast_points = [long, lat] of full coast
plant_loc = [0 0];

%% Plot the cities

geoscatter(cities(:,1), cities(:,2),100,'.k')
geolimits([min(cities(:,1)) max(cities(:,1))],[min(cities(:,2)) max(cities(:,2))])

min_lon = min(cities(:,2));
max_lon = max(cities(:,2));
min_lat = min(cities(:,1));
max_lat = max(cities(:,1));

if coast_direction == 0 || coast_direction == 1
    coast_points(or(coast_points(:,2) > max_lat, coast_points(:,2) < min_lat),:) = [];
else
    coast_points(or(coast_points(:,1) > max_lon, coast_points(:,1) < min_lon),:) = [];
end

disp("Filter by distance to coastal point instead")
geoplot(coast_points(:,2), coast_points(:,1),'-k','Linewidth', 2);

%{
coeffs = polyfit(coast_sort(:,1), coast_sort(:,2),10);
lat_est = polyval(coeffs, coast_sort(:,1));
geoplot(lat_est,coast_sort(:,1), 'LineWidth',2, 'color', 'red')
%}


end