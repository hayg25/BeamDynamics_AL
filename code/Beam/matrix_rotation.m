function [T]=matrix_rotation(teta)
% give 6*6 transfert matrix for a rotation along main axis
% teta in radian

C=cos(teta);
S=sin(teta);

T=eye(6);
T(1,1)=C;T(2,2)=C;T(3,3)=C;T(4,4)=C;
T(1,3)=S;T(3,1)=-S;T(2,4)=S;T(4,2)=-S;

return