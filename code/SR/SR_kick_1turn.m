function [phasespace,U]=SR_kick_1turn(phasespace,E,E0,R,I2,I4,acc)
% Add quantum E exitation + damping over 1 turn minus losses U0 
% For bunch length estimation versus some wakefield compnents
% need synchrotron integral I2 & I4  to be continued
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% E energy in MeV
% E0 restmass
% I2 synchrotron integral
% I4 synchrotron integral
% acc : accelerateur de damping !!
% U mean losses

%
if nargin<7;acc=1;end 
%
Cq=3.84e-13;
r0=2.818e-15;
pieps=1.1e-10;  % 4 pi eps0
q    =1.6e-19;  % electron charge
gam=(E+E0)/E0;
%
U =2*q/pieps/3*gam^4*(I2)*1e-6;        % Synchrotron loss in MeV (mean value)
du=2*r0*gam^3/3*(2*I2+I4)*acc;         % damping synchrotron
du2=sqrt(2*Cq*gam^2/(2+I4/I2)/R*du);   % excitation synchrotron 

% Apply to energy for each particles
np=length(phasespace(6,:));
phasespace(6,:)=phasespace(6,:)*(1-du) + du2*randn(1,np) - U/E;  
return

