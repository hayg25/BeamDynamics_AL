function [T]=matrix_coin(strength)
% give 6*6 transfert matrix for dipole edge
% 


teta=strength(1);% pole face rotation
rho= strength(2);
Lff= strength(3);% fringe effect
Kg = Lff/6;
phi= Kg/rho*(1+sin(teta)^2/cos(teta));

T=eye(6);
T(2,1)=+tan(teta)/rho;
T(4,3)=-tan(teta-phi)/rho;

return