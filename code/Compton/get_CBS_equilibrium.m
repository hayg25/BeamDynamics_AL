function [sige,U,Exmax]=get_CBS_equilibrium(E,E0,El,Eph,sig)
% give E spread and mean losses U
% from Compton backscattering
% From Huang Ruth PRL 1998 Vol 80  976
% E energy in MeV
% E0 restmass
% El  laser pulse energy in joule
% Eph laser photon energy in eV

%
sigz=6.6527e-29;  % interaction cross section
r0=2.818e-15;
q    =1.6e-19;  % electron charge
gam=(E+E0)/E0;
eEl=El/q*1.e-6; % laser in MeV
Eph=Eph*1e-6;   % phton in MeV

%
Z   =4*E*Eph/E0^2;
Exmax=E*Z./(1+Z);                   % Max scattered photon 
U =sigz*eEl/pi/sig^2*gam^2/2.2;         % Compton mean loss in MeV (mean value)
sige=sqrt(7/5*Eph*gam/E0);          % rms dE/E spread

% rms transverse emittance equi
eps=3/10*Eph*0.1/E0;

return

