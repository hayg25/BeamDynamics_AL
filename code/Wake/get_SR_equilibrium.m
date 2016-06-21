function [sige,U0]=get_SR_equilibrium(E,E0,R,I2,I4)
% give E spread and mean losses U0
% need synchrotron integral I2 & I4  to be continued
% E energy in MeV
% E0 restmass
% I2 synchrotron integral
% I4 synchrotron integral
% acc : accelerateur de damping !!
if nargin<7;acc=1;end 
%
Cq=3.84e-13;
pieps=1.1e-10;  % 4 pi eps0
q    =1.6e-19;  % electron charge
gam=(E+E0)/E0;
%
U0  =2*q/pieps/3*gam^4*(2*pi/R)*1e-6;     % Synchrotron loss in eV (mean value)
sige=sqrt(Cq*gam^2/(2+I4/I2)/R);          % E spread

return

