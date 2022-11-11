function [phirow] = calcphirow(xi,centers,s)
%This calculates a single row of the RBF regressor matrix

NumCenters = size(centers,1);           %Number of center points defined
phirow = zeros(1,NumCenters+1);         %Preallocate w/ numcenters+1 to include constant

phirow(1) = 1;

for i = 2:NumCenters+1
    phirow(:,i) = exp(-norm(xi-centers(i-1,:)) / (2*s^2));
end


end