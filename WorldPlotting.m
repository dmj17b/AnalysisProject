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
rng(20004) %Random Seed to keep our results the same
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
geolimits(lat_limits,long_limits)
geoscatter(cities(:,1), cities(:,2),100,idx,'Marker','.')
geoscatter(C(:,1), C(:,2),max_marker*4,'.m')
colormap jet
geobasemap colorterrain
colorbar

group_idx = idx;

%% Coasts
Coasts = load('coastlines');
long_filter = and(Coasts.coastlon > long_limits(1), Coasts.coastlon < long_limits(2));
lat_filter = and(Coasts.coastlat > lat_limits(1), Coasts.coastlat < lat_limits(2));
Coasts.coastlon(~and(long_filter, lat_filter),:) = [];
Coasts.coastlat(~and(long_filter, lat_filter),:) = [];

%Manual Filters

long_filter = Coasts.coastlon > 10;
lat_filter = Coasts.coastlat > 10;
Coasts.coastlon(and(long_filter, lat_filter),:) = [];
Coasts.coastlat(and(long_filter, lat_filter),:) = [];

long_filter = and(Coasts.coastlon > 8, Coasts.coastlon < 9);
lat_filter = and(Coasts.coastlat > 2, Coasts.coastlat < 4.1);
Coasts.coastlon(and(long_filter, lat_filter),:) = [];
Coasts.coastlat(and(long_filter, lat_filter),:) = [];

figure
geobasemap colorterrain
hold on
geoscatter(cities(:,1), cities(:,2),size_map,color_map,'Marker','.')
geolimits(lat_limits,long_limits)

[Coasts.coastlon, I] = sort(Coasts.coastlon);
Coasts.coastlat = Coasts.coastlat(I);

coast_sort = SortGeo(Coasts.coastlon, Coasts.coastlat);
geoplot(coast_sort(:,2), coast_sort(:,1),'-k','Linewidth', 2);

%% Closest Points to Coast
closest_coastal = zeros(size(C));

for i = 1:size(C,1)
    [~,idx] = min(vecnorm(C(i,2:-1:1)-coast_sort,2,2));
    closest_coastal(i,:) = coast_sort(idx,:);
end

for i = 1:size(C,1)
    
    figure
    geobasemap colorterrain
    hold on
    %geoscatter(closest_coastal(i,2), closest_coastal(i,1),150,'m','Marker','.' );
    %geoscatter(C(i,1), C(i,2),max_marker*4,'.m')
    geoscatter(cities(group_idx==i,1), cities(group_idx==i,2),100,'.k')
    geolimits([min(cities(:,1)) max(cities(:,1))],[min(cities(:,2)) max(cities(:,2))])

    sol = PlanCluster(cities(group_idx==i,:), coast_sort,closest_coastal(i,:));
    fprintf("Optimal Plant Location: (%0.2f, %0.2f)\n",sol(1),sol(2))
    geoscatter(sol(1), sol(2),100,'dg','filled')
    drawnow
end

