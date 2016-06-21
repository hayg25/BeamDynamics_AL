function [phasespace]=pass_ELENS(phasespace,K,flag) 
% Electrical lens symplectic pass
% Mode thine lens focusing in both planes
% Focusing if K>0

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
d =phasespace(6,:);

%
K= -K./(1+d);
xp1=xp + K.*x;
zp1=zp + K.*z;

%
phasespace(2,:)=xp1;
phasespace(4,:)=zp1;

return
    
