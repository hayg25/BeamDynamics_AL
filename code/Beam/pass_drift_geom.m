function [phasespace]=pass_drift_geom(phasespace,L) 
% Exact drift pass
% L length m


%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);


%
dd  =sqrt(1-xp.^2-zp.^2); 
x1  =x + xp./dd*L;
z1  =z + zp./dd*L;
s1  =s - L*(1-sqrt(1+xp.^2+zp.^2));

%
phasespace(1,:)=x1;
phasespace(3,:)=z1;
phasespace(5,:)=s1;


return
    
