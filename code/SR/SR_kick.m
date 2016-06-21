function [phasespace]=SR_kick(phasespace,E,R,L)
% Add E losses & quantum exitation per meter of dipole
% phasespace
% E energy in MeV
% R bending radius in meter
% L integration length

%
Cq=3.84e-13;
r0=2.818e-15;
pieps=1.1e-10;  % 4 pi eps0
q    =1.6e-19;  % electron charge
E0   =0.511;    % restmass in MeV
gam=(E+E0)/E0;
R=abs(R);
I2=(L/R^2);
I4=0;  % to simplified
% 
U =2*q/pieps/3*gam^4*(I2)*1e-6;        % Synchrotron loss in MeV (mean value)
du=2*r0*gam^3/3*(2*I2+I4);             % damping synchrotron
du2=sqrt(2*Cq*gam^2/(2+I4/I2)/R*du);   % excitation synchrotron 

% Apply to energy for each particles
np=length(phasespace(6,:));
phasespace(6,:)=phasespace(6,:)*(1-du) + du2*randn(1,np) - U/E;  
return

