function [nu]=get_tune
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC
% return tunes : nu=[nux nuz nus]
global DYNAMIC

% 
T=DYNAMIC.matrix; % total matrix
nux=0;
trx=0.5*( T(1,1) + T(2,2) );
if abs(trx)<=1
   nux=acos(trx)/2/pi;
   if T(1,2)<0; nux=1-nux;end
end

nuz=0;
trz=0.5*( T(3,3) + T(4,4) );
if abs(trz)<=1
   nuz=acos(trz)/2/pi;
   if T(3,4)<0; nuz=1-nuz;end
end

nus=0;
trs=0.5*( T(5,5) + T(6,6) );
if abs(trs)<=1
   nus=acos(trs)/2/pi;
   if T(5,6)<0; nus=1-nus;end
end

nu=[nux nuz nus];
return