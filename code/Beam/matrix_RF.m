function [T]=matrix_RF(K)
% give 6*6 transfert matrix for simple RF kick used in ring
% 
T=eye(6);
T(6,5)=K;
return