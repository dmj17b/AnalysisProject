clc; close all

%% Load Data
long_limits = [-20 20];
lat_limits = [-15 15];
cities = readmatrix("WorldCities.xlsx","NumHeaderLines",1);
cities(isnan(cities(:,3)),:) = [];
cities(cities(:,3) == 0,:) = [];
long_filter = and(cities(:,2) > long_limits(1), cities(:,2) < long_limits(2));
lat_filter = and(cities(:,1) > lat_limits(1), cities(:,1) < lat_limits(2));
cities(~and(long_filter, lat_filter),:) = [];

%% Create Map
max_marker = 125;
min_marker = 50;
scaled_population = cities(:,3)/max(cities(:,3));
%size_map = max(max_marker*scaled_population,min_marker);
color_map = min(100000*cities(:,3)/max(cities(:,3)),1000);
size_map = max(max_marker*color_map/max(color_map),min_marker);


%% Pretty Population Map
geoscatter(cities(:,1), cities(:,2),size_map,color_map,'Marker','.')
colormap jet
geobasemap colorterrain
colorbar

%% K-Means Map Weighted On Population

[idx,C] = Weighted_KMeans(cities(:,1),cities(:,2),cities(:,3),16000000, 1000);

cla
hold on
geoscatter(C(:,1), C(:,2),max_marker*4,'.m')
geolimits(lat_limits,long_limits)
geoscatter(cities(:,1), cities(:,2),100,idx,'Marker','.')
colormap jet
geobasemap colorterrain
colorbar
