function [g1,g3,CXZ, Np]=bunch_image(phasespace,nbin,w)
% Return 2D desnisti image CXZ from phasespace binning
% W : window Xmax and Zmax
pmax1=w(1);[phasespace]=acceptance(phasespace,1,pmax1);
pmax3=w(2);[phasespace]=acceptance(phasespace,3,pmax3);

% Mesh over X
p1=phasespace(1,:);g1=(-pmax1:(2*pmax1)/(nbin(1)-1):pmax1);
% Mesh over Z
p3=phasespace(3,:);g3=(-pmax3:(2*pmax3)/(nbin(2)-1):pmax3);

% Imported from the net
[CXZ] = hist2(p1,p3,g1,g3);
Np = sum(sum(CXZ));
b=4;h=ones(b)/b^2;
CXZ=filter2(h,CXZ);
n1=length(g1);
n3=length(g3);
CXZ=CXZ(1:n3,1:n1);

return