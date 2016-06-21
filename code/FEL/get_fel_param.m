function [lambda] = get_fel_param(E,K,ond)
%   input : K-Energy [MeV], Kd, deflexion parameter, ond period
%   Return :lambda=und/2/gam^2(1+aw^2)
%   from      lambda=und/2/gam^2(1+aw^2)
gam =(E+0.511*0)/0.511; 
lambda=ond/2/gam^2*(1+K^2/2);

return

