function [phasespace]=pass_dipole(phasespace,l,r) 
% Exact dipole pass, sector only
% From hamiltonian integation (ex. Nadolski theses)
% r = radius m
% teta= angle rad
% x,z radial pos       l long pos
% xp=Px/P  zp=Pz/P     d=(P-P0)/P0

r=r(1); % index not taken into account
h=1/r;
b1=h;

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);

%
xp=xp.*(1+d); % convert to Px/P0
zp=zp.*(1+d); % convert to Px/P0
dd  =sqrt((1+d).^2-xp.^2-zp.^2); 
xp1 =xp.*cos(h*l) + (dd-b1*(r+x))*sin(h*l);
%xp1 =xp*cos(h*l) - b1*x*sin(h*l) + (dd-1)*sin(h*l);
dxp1=-h*xp.*sin(h*l) + h*(dd-b1*(r+x))*cos(h*l);
%dxp1 =-h*xp*sin(h.*l) - h*b1*x*cos(h*l) + h*(dd-1).*cos(h*l);
x1  =(h*sqrt((1+d).^2-xp1.^2-zp.^2)-dxp1-b1)/h/b1;  
%x1  = -dxp1/h/h + (sqrt((1+d).^2-xp1.^2-zp.^2)-1)/h;
%
ddz=sqrt((1+d).^2-zp.^2);
aa =asin(xp./ddz)-asin(xp1./ddz);
z1 =z + zp.*aa./b1 + zp.*h/b1*l;
zp1=zp;
%
s1=s + l - (1+d).*aa/b1 - (1+d)/b1*h*l;
d1=d;
%
xp1=xp1./(1+d);  % convert back to Px/P
zp1=zp1./(1+d);  % convert back to Pz/P
phasespace(1,:)=x1;
phasespace(2,:)=xp1;
phasespace(3,:)=z1;
phasespace(4,:)=zp1;
phasespace(5,:)=s1;
phasespace(6,:)=d1;


return
    
