function [phasespace,U]=CBS_wake(phasespace,E,E0,El,Eph,sig,acc)
% Add quantum E exitation + damping over 1 turn minus losses U0 
% From Compton backscattering, no crossing angle
% From Huang Ruth PRL 1998 Vol 80  976
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% E energy in MeV
% E0  restmass
% El  laser pulse energy in joule
% Eph laser photon energy in eV
% sig E_beam = Laser_beam size at interacion point
% acc : accelerateur de damping !!
% U mean losses

%
if nargin<7;acc=1;end 
%
sigz=6.6527e-29;  % interaction cross section
%r0=2.818e-15;
q    =1.6e-19;  % electron charge
gam=(E+E0)/E0;
eEl=El/q*1.e-6; % laser in MeV
Eph=Eph*1e-6;   % phton in MeV

%
U =sigz*eEl/pi/sig^2*gam^2;      % Compton mean loss in MeV (mean value)
du=2*U/E*acc;                    % Damping Compton
du2=2*sqrt(7/5*(U*Eph*acc))/E0;  % Excitation Compton

% Apply to energy for each particles
np=length(phasespace(6,:));
phasespace(6,:)=phasespace(6,:)*(1-du) + du2*randn(1,np) - U/E;  
return

