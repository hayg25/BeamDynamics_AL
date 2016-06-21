function [K,aw,B,Kd] = get_und_param(E,lambda,ond)
%   input : Energy [MeV], lambda [m] und period [m]
%   Return :
%           K=rho   for beta code [m]
%           aw      for genesis
%           B       [T]
%           Kd      deflexion parameter
% from      lambda=und/2/gam^2(1+aw^2)

% Get undulator strength K aw and B
gam =(E+0.511)/0.511;
brho=E*1e6/3e8;
aw  =sqrt(2*lambda*(gam)^2/ond-1);
Kd  =sqrt(2)*aw;
B   =sqrt(2)*aw/93.4/ond;
K   =brho/B;     % beta input OK with Genesis ID foc

return

