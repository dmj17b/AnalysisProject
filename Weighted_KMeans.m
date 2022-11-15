function [idx,C] = Weighted_KMeans(x,y,pop,max_pop, iters)

N = ceil(sum(pop)/max_pop);

range_x = [min(x) max(x)];
range_y = [min(y) max(y)];

C(:,1) = rand(N,1)*(diff(range_x)) + range_x(1);
C(:,2) = rand(N,1)*(diff(range_y)) + range_y(1);

points = [x y zeros(length(x),1)]; %x,y,idx

for i = 1:iters
    C_pops = zeros(N,1);
    for j = 1:size(points,1)
        [~, idx] = mink(vecnorm(points(j,1:2) - C,2,2),N);
        
        for it = 1:N
            if(C_pops(idx(it))+pop(j) < max_pop)
                points(j,3) = idx(it);
                C_pops(idx(it)) = C_pops(idx(it)) + pop(j);
                break;
            end
        end
        
    end
    for k = 1:N
        filt = points(:,3)==k;
        if(sum(filt) > 0)
            %hold on
            C(k,:) = sum(pop(filt).*points(filt,1:2)/sum(pop(filt)));
            %{
            geoscatter(points(points(:,3)==k,1),points(points(:,3)==k,2),50,'.k')
            geoscatter(C(k,1), C(k,2),500,'.m')
            geolimits([-15 15], [-20 20])
            title("K = " + string(k))
            drawnow 
            %}
        else
            C(k,1) = rand*(diff(range_x)) + range_x(1);
            C(k,2) = rand*(diff(range_y)) + range_y(1);
        end
    end
    %cla
end

idx = points(:,3);
C = C(:,1:2);

%{
## K-Means Clustering 
1. Choose the number of clusters(K) and obtain the data points 
2. Place the centroids c_1, c_2, ..... c_k randomly 
3. Repeat steps 4 and 5 until convergence or until the end of a fixed number of iterations
4. for each data point x_i:
       - find the nearest centroid(c_1, c_2 .. c_k) 
       - assign the point to that cluster 
5. for each cluster j = 1..k
       - new centroid = mean of all points assigned to that cluster
6. End 
%}