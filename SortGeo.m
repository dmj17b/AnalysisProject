function sortedGeo = SortGeo(long, lat)
sortedGeo = zeros(length(lat),2);
[~,idx] = min(long);
sortedGeo(1,:) = [long(idx) lat(idx)];


for i = 2:length(lat)
    [~, idx] = min(vecnorm(sortedGeo(i-1,:) - [long lat],2,2));
    sortedGeo(i,:) = [long(idx) lat(idx)];
    long(idx) = [];
    lat(idx) = [];
end
end