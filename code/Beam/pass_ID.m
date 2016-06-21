function [phasespace]=pass_ID(phasespace,K,L) 
% QP symplectic pass
% K : normalized strength
% L : length
K=K(1);
if (K<=0); [phasespace]=pass_drift(phasespace,L); return;end
K=1/K/sqrt(2); % for planar undulator (mean radius over 1 period sinus)

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);


k  =K./(1+d);kl=k.*L;
%k  =K;kl=k.*L;
cs = cos(kl) ;ss=sin(kl) ;

% H drift
dd  =sqrt(1-xp.^2-zp.^2);
x1  =x + xp./dd*L;
xp1 =xp;
% V quad
z1 = z.*cs    + zp.*ss./k;
zp1=-z.*k.*ss + zp.*cs;

%
s1  =s - L*(xp.^2+zp.^2)/2; %not good !


phasespace(1,:)=x1;
phasespace(2,:)=xp1;
phasespace(3,:)=z1;
phasespace(4,:)=zp1;
phasespace(5,:)=s1;

return

