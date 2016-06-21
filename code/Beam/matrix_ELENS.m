function [T]=matrix_ELENS(strength)
% give 6*6 transfert matrix Electrical lens
% Mode thine lens focusing in both planes
% Focusing if K>0

K=strength(1);% 

T=eye(6);
T(2,1)=-K;
T(4,3)=-K;

return