function [Tx,Tz,nu,flag]=get_transverse_matching(T)
% find the cyclic Twiss function
% return tunes : Twiss and nu=[nux nuz]
% Flag=1 if solution exist, 0 if not
global DYNAMIC

if nargin == 0 ;T=DYNAMIC.matrix;end % total matrix


% H plane
flagx=0;
nux=0;Tx=[0 0 ; 0 0];
trx=0.5*( T(1,1) + T(2,2) );
if abs(trx)<1
    flagx=1;
    nux=acos(trx)/2/pi;
    if T(1,2)<0; nux=1-nux;end
    bx=T(1,2)/sin(2*pi*nux);
    ax=(T(1,1)-T(2,2))/sin(2*pi*nux)/2;
    gx=(1+ax^2)/bx;
    Tx=[bx  ax ; ax  gx];
end


% V plane
flagz=0;
nuz=0;Tz=[0 0 ; 0 0];
trz=0.5*( T(3,3) + T(4,4) );
if abs(trz)<1
    flagz=1;
    nuz=acos(trz)/2/pi;
    if T(3,4)<0; nuz=1-nuz;end
    bz=T(3,4)/sin(2*pi*nuz);
    az=(T(3,3)-T(4,4))/sin(2*pi*nuz)/2;
    gz=(1+az^2)/bz;
    Tz=[bz  az ; az  gz];

end

flag=flagx||flagz;

nu=[nux nuz];
return