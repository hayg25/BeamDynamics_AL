function [phasespace]=pass_CO(phasespace,K,flag) 
% Edge symplectic pass
% K : normalized strength : teta ,r
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
phi= K(3)/6/K(2)*(1+sin(K(1))^2/cos(K(1)));
%Kz=-tan(K(1) - phi + Dxp*d  )/K(2)./(1+d);
Kz=-tan(K(1) - phi + xp*flag  )/K(2)./(1+d);
zp1=zp + Kz.*z;

%
phasespace(2,:)=xp1;
phasespace(4,:)=zp1;

return
    
