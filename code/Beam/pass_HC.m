function [phasespace]=pass_HC(phasespace,K) 
% Thin H corrector pass
%

%
xp=phasespace(2,:);
d =phasespace(6,:);

%
xp1  =xp + K./(1+d);

%
phasespace(2,:)=xp1;


return
    