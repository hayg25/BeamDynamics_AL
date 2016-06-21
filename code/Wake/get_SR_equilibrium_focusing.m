function [eps,sigsmin,sigemax,sigsmax,sigemin,nu,U0]=get_SR_equilibrium_focusing(E,E0,R,I2,I4,r56,r65)
% give Emit, Espread length spread and mean losses U0
% general case with strong RF focusing : r56*r65 large ! 
% 1 RF + 1 r56 drift, like a FO lattice
% from L. Falbo, Longitudinal dynamic in strong RF focusing, PRL
% assume r56 linear with s in dipole
% need synchrotron integral I2 & I4 (I4 usually close to 0)
% E energy in MeV
% E0 restmass
% I2 synchrotron integral
% I4 synchrotron integral
%
Cq=3.84e-13;
pieps=1.1e-10;  % 4 pi eps0
q    =1.6e-19;  % electron charge
gam=(E+E0)/E0;
%
U0  =2*q/pieps/3*gam^4*(2*pi/R)*1e-6;     % Synchrotron loss in eV (mean value)
%
c  =1+r56*r65./2;
nu =acos(c)/2/pi;
bmax=-r56./sqrt(1-c.^2);
bmin=sqrt(1-c.^2)./r65;
sigemax=sqrt(Cq*gam^2/(2+I4/I2)/R * (1 + (r56/bmin)^2/12  ));   % E spread max (L. Falbo)
eps    = sigemax^2*bmin;
sigsmin= sqrt(bmin*eps);
sigsmax= sqrt(bmax*eps);
sigemin= sqrt(eps/bmax);

return

