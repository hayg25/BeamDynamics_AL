function [phasespace]=pass_drift(phasespace,L) 
% Exact drift pass, sector only
% From hamiltonian integation (ex. Nadolski theses)
% L length m
% x,z radial pos       l long pos
% xp=Px/P  zp=Pz/P     d=(P-P0)/P0

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);

%
dd  =sqrt(1-xp.^2-zp.^2);
%dd  =sqrt((1+d).^2-xp.^2-zp.^2);  
x1  =x + xp./dd*L;
z1  =z + zp./dd*L;
s1  =s - L*(1./dd - 1);
%s1  =s - L*(xp.^2+zp.^2)/2;

%
phasespace(1,:)=x1;
phasespace(3,:)=z1;
phasespace(5,:)=s1;


return
    
% xp=xp.*(1+d);
% zp=zp.*(1+d);
% %
% dd  =sqrt((1+d).^2-xp.^2-zp.^2); 
% x1  =x + xp./dd*L;
% z1  =z + zp./dd*L;