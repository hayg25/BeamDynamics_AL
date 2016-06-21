function [phasespace]=pass_QP(phasespace,K,L) 
% QP symplectic pass
% K : normalized strength
% L : length
% x,z radial pos       l long pos
% xp=Px/P  zp=Pz/P     d=(P-P0)/P0

if (K==0); [phasespace]=pass_drift(phasespace,L); return;end

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);

if (K>0)
    k  =sqrt(K./(1+d));kl=k.*L;
    cs = cos(kl) ;ss=sin(kl) ;
    ch = cosh(kl);sh=sinh(kl);
    x1 = x.*cs    + xp.*ss./k;
    xp1=-x.*k.*ss + xp.*cs;
    z1 = z.*ch    + zp.*sh./k;
    zp1= z.*k.*sh + zp.*ch;
    ss2=sin(2*kl);sh2=sinh(2*kl);
    dl =     k.*(0.5*ss2-kl)/4.*x.^2 - k.*(0.5*sh2-kl)/4.*z.^2;
    dl =dl - (0.5*ss2./k+L)/4.*xp.^2 - (0.5*sh2./k+L)/4.*zp.^2;
    dl =dl + ss.^2.*x.*xp/2          - ss.^2.*z.*zp/2;
    s1=s+dl;
elseif (K<0)
    k  =sqrt(-K./(1+d));kl=k.*L;
    cs = cos(kl) ;ss=sin(kl) ;
    ch = cosh(kl);sh=sinh(kl);
    x1 = x.*ch    + xp.*sh./k;
    xp1= x.*k.*sh + xp.*ch;
    z1 = z.*cs    + zp.*ss./k;
    zp1=-z.*k.*ss + zp.*cs;
    ss2=sin(2*kl);sh2=sinh(2*kl);
    dl =   - k.*(0.5*sh2-kl)/4.*x.^2 + k.*(0.5*ss2-kl)/4.*z.^2;
    dl =dl - (0.5*sh2./k+L)/4.*xp.^2 - (0.5*ss2./k+L)/4.*zp.^2;
    dl =dl - sh.^2.*x.*xp/2          + ss.^2.*z.*zp/2;
    s1=s+dl;
end

phasespace(1,:)=x1;
phasespace(2,:)=xp1;
phasespace(3,:)=z1;
phasespace(4,:)=zp1;
phasespace(5,:)=s1;

return

