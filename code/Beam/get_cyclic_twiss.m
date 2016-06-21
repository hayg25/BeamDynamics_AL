function [nu, twiss]=get_cyclic_twiss(T)
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC
% return tunes : nu=[nux nuz nus]
global DYNAMIC

if nargin == 0 ;
T=DYNAMIC.matrix; % total matrix
end

% H plane
nux=0;bx=1;ax=0;
trx=0.5*( T(1,1) + T(2,2) );
if abs(trx)<=1
   nux=acos(trx);
   if T(1,2)<0; nux=1-nux;end
   bx=+T(1,2)/sin(nux);
   %gx=-T(2,1)/sin(nux);
   ax=(T(1,1)-cos(nux))/sin(nux);
end

% V plane
nuz=0;bz=1;az=0;
trz=0.5*( T(3,3) + T(4,4) );
if abs(trz)<=1
   nuz=acos(trz);
   if T(3,4)<0; nuz=1-nuz;end
   bz=+T(3,4)/sin(nuz);
   %gz=-T(4,3)/sin(nuz);
   az=(T(4,4)-cos(nuz))/sin(nuz);
   
end

nu=[nux nuz]/2/pi;
twiss=[bx ax bz az];


return