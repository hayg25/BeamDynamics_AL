function [phasespace,U]=SR_kick_1turn_6D(phasespace,E,E0,R,I2,I4,I5,K,twiss,disp,acc)
% Add quantum E exitation + damping over 1 turn minus losses U0 
% Add quantum EPS exitation + damping over 1 turn 
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% E energy in MeV
% E0 restmass
% I2 synchrotron integral
% I4 synchrotron integral
% I5 synchrotron integral
% K transverse coupling 
% Twiss data at kick location
% Disp data at kick location
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
% long
U  =2*q/pieps/3*gam^4*(I2)*1e-6;       % Synchrotron loss in MeV (mean value)
du =2*r0*gam^3/3*(2*I2+I4)*acc;        % damping synchrotron
du2=sqrt(2*Cq*gam^2/(2+I4/I2)/R*du);   % excitation synchrotron 
% Horizontal
de =2*r0*gam^3/3*(I2+I4)*acc;          % damping synchrotron
de2=sqrt(Cq*gam^2/(1+I4/I2)*de*I5*R/pi*(1-K/2));% excitation synchrotron
% eps=dex2^2/dex/2
% assume vertical=Horizontal*coupling 

% Apply to energy for each particles
np=length(phasespace(6,:));
phasespace(1,:)=phasespace(1,:)*(1-de) + de2*randn(1,np)*sqrt(twiss(1)); 
phasespace(3,:)=phasespace(3,:)*(1-de) + de2*randn(1,np)*sqrt(K*twiss(3));

%phasespace(6,:)=phasespace(6,:)*(1-du) + du2*randn(1,np) - U/E; 
dd=-du*phasespace(6,:)+du2*randn(1,np);
phasespace(6,:)=phasespace(6,:) + dd - U/E;  
% Add dispersion position to remove extra H emittance
phasespace(1:4,:)=phasespace(1:4,:) + disp(1:4)*dd;
return

