function [phasespace]=pass_dipole_geom(phasespace,l,r0) 
% Exact horizontal dipole pass, sector only
% From geom : edge naturally included in horizontal plane
% r0  = on momentum radius m
% l   = on momentum path length
% teta= on momentum angle rad

teta0=l/r0;

%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);

%
r  =r0.*sqrt((1+d).^2-zp.^2); % arc radius on x,s plan
dd =sqrt(1-xp.^2-zp.^2); 
ddz=sqrt(1-zp.^2); 

% coordinates of arc center
x0=r0+x-r.*dd./ddz;
y0=r.*xp./ddz;

% coordinate on exit from origine
tt=tan(teta0);
b0=x0+y0.*tt;
X1=(b0 + sqrt(b0.^2 - (1+tt^2).*(x0.^2 +y0.^2 -r.^2)))./(1+tt^2);
Y1=X1.*tt;
% coordinate on exit from central traj
x1=sqrt(X1.^2 + Y1.^2)-r0;

% deviation on x,s plan
teta1 = acos( ((r0+x-x0).*(X1-x0) - y0.*(Y1-y0))./r.^2 ) ;
xp1=xp+teta0-teta1;

%
lx=r.*teta1; % lentgh on x,s plan
l1=lx./ddz;  % path lentgh 
z1=z+zp.*l1;

%
s1=s+l-l1;

%
phasespace(1,:)=x1;
phasespace(2,:)=xp1;
phasespace(3,:)=z1;
phasespace(5,:)=s1;



return
    

% teta=teta0;
% r =r0.*(1+d);
% 
% x0=r0+x-r./sqrt(1+xp.^2);
% y0=r.*xp;
% 
% tt=tan(teta);
% b0=x0+y0.*tt;
% X1=(b0 + sqrt(b0.^2 - (1+tt.^2).*(x0.^2 +y0.^2 -r.^2)))./(1+tt.^2);
% Y1=X1.*tt;
% x1=(X1 - r0*cos(teta0))./cos(teta0);
% 
% teta1 = acos( ( cos(xp).*(X1-x0) + sin(xp).*(Y1-y0)  )./r );   
% xp1=-xp+teta0-teta1;
% 
% %
% z1 =z+zp.*r0.*teta0;
% zp1=zp;
% %
% s1=s+r.*teta1-r0*teta0;
% d1=d;



