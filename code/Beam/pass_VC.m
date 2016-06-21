function [phasespace]=pass_VC(phasespace,K) 
% Thin V corrector pass
%

%
zp=phasespace(4,:);
d =phasespace(6,:);

%
zp1  =zp + K./(1+d);

%
phasespace(4,:)=zp1;


return
    