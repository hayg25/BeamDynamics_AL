function [phasespace]=pass_CO_geom(phasespace,K,Dxp) 
% Edge symplectic pass
% K : normalized strength
% Dxp : Horizontal dispersion angle
% tan(strength(1))/strength(2)
%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
d =phasespace(6,:);

%
Kx=tan(K(1)) / K(2) ./(1+d);
xp1=xp + Kx.*x;
%
Kz=-tan(K(1) + Dxp*d )/K(2)./(1+d);
zp1=zp + Kz.*z;

%
phasespace(2,:)=xp1;
phasespace(4,:)=zp1;


return
    
