function [phasespace]=track_bunch_1turnmap(phasespace,tab)
% tracking bunch trought 1 turn map
% non_linear only in energy
% tab = bx ax bz az Dx Dxp nux nuz  chrox  chroz
%global  LATTICE DYNAMIC
%
% to finish

%
bx =tab(1);ax =tab(2);gx=(1+ax^2)/bx;
bz =tab(3);az =tab(4);gz=(1+az^2)/bz;
Dx =tab(5);Dxp=tab(6);
nux=tab(7);nuz=tab(8);
chx=tab(9);chz=tab(10);
%
x =phasespace(1,:);
xp=phasespace(2,:);
z =phasespace(3,:);
zp=phasespace(4,:);
s =phasespace(5,:);
d =phasespace(6,:);
%
if (chx==0)&&(chz==0)
    tx=2*pi*(nux);cx=cos(tx);sx=sin(tx);
    tz=2*pi*(nuz);cz=cos(tz);sz=sin(tz);
else
    tx=2*pi*(nux+chx.*d);cx=cos(tx);sx=sin(tx);
    tz=2*pi*(nuz+chz.*d);cz=cos(tz);sz=sin(tz);
end
%

t11= cx+ax*sx;t12=bx*sx;t16=(1-t11).*Dx-t12*Dxp;
t21=-gx*sx;t22=cx-ax*sx;t26=-t21*Dx-(1-t22)*Dxp;

t33= cz+az*sz;t34=bz*sz; %assume Dz=0
t43=-gz*sz;t44=cz-az*sz;

t51=+t21*Dx-(1-t11)*Dxp;t52=-(1-t11).*Dx+t12*Dxp;

T=[t11 t12 0 0 0 t16 ; t21 t22 0 0 0 t26;...
   0  0 t33 t34  0 0 ; 0  0 t43  t44 0 0  ;...
   t51 t52  0  0  1 0; 0  0  0  0  0  1];
T
return





