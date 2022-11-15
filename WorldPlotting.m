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
rng(1999) %Random Seed to keep our results the same
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
%{
for i = 1:max(idx)
    figure
    geobasemap colorterrain
    hold on
    geoscatter(cities(idx==i,1), cities(idx==i,2),100,'.k')
    geolimits([min(cities(idx==i,1)) max(cities(idx==i,1))],[min(cities(idx==i,2)) max(cities(idx==i,2))])
end
%}
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
geoscatter(Coasts.coastlat, Coasts.coastlon,150,'k','Marker','.' );
geolimits(lat_limits,long_limits)

[Coasts.coastlon, I] = sort(Coasts.coastlon);
Coasts.coastlat = Coasts.coastlat(I);

geoplot(Coasts.coastlat, Coasts.coastlon,'-k','Linewidth', 2);

coeffs = polyfit(Coasts.coastlon, Coasts.coastlat);
lat_est = polyval(coeffs, Coasts.coastlon);
geoplot(lat_est,Coasts.coastlon, 'LineWidth',2, 'color', 'red')