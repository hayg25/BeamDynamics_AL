function [phasespace]=pass_QFF(phasespace,K) 
% Apply QP Fringe field pass in kick approx (thin lens)
% Octupole like (Lee Whiting)
% K : G/Brho of concerned quad


%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
dd=(1+phasespace(6,:));

%
K=K./dd/4;
%
% xp=xp.*dd;
% zp=zp.*dd; % in test ?

xx =x.^2+z.^2;
x1 =x +K.*(x.^2 + 3*z.^2).*x/3; 
xp1=xp-K.*(xx.*xp -2*x.*z.*zp); 
z1 =z -K.*(z.^2 + 3*x.^2).*z/3; 
zp1=zp+K.*(xx.*zp - 2*x.*z.*xp); 

% xp1=xp1./dd;
% zp1=zp1./dd; %?

%
phasespace(1,:)=x1;
phasespace(2,:)=xp1;
phasespace(3,:)=z1;
phasespace(4,:)=zp1;

return
    
