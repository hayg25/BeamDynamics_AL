function [phasespace]=pass_mult(phasespace,M) 
% Apply multipole pass in kick approx (thin lens)
% M=[n K] : order , normalized strength * length 
% n=2 for quad
% Test :
%   pass_mult(phasespace0,[2 1]) = pass_QP(phasespace0,1e5,1e-5) = OK
%   pass_mult(phasespace0,[3 1]) = pass_SX(phasespace0,1)        = OK

n=M(1);
K=M(2);
K=K./(1+phasespace(6,:));
% Cylindrical coordinates
[t,r]=cart2pol(phasespace(1,:),phasespace(3,:));
rn=power(r,n-1);
ct=cos(t);
st=sin(t);
%
% Cylindrical B
% Upright multipole
Br=rn.*sin(n*t);
Bt=rn.*cos(n*t);
% Skew multipole

%
% Cartesian B
Bx=Br.*ct-Bt.*st;
Bz=Br.*st+Bt.*ct;
%
% Apply kick
phasespace(2,:)=phasespace(2,:)-K.*Bz;
phasespace(4,:)=phasespace(4,:)+K.*Bx;

return
    
