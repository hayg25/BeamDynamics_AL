function [phasespace]=pass_RF(phasespace,E,Vrf,Frf,phi) 
% Apply rf pass in ring for long data
% Frf : frequency in Hz
% Vrf : energy gain (MeV)
% E     energy   (MeV)
% phi phase in    0 = max acceleration on crest

%
cl=3e8;
kl=2*pi*Frf/cl;
ds=phi/kl;

%
dv=Vrf*cos(kl*(phasespace(5,:)-ds))/E;
phasespace(6,:)=phasespace(6,:)+dv ;

% Transverse damping : to comment when using SR_kick_1turn_6D
phasespace(2,:)=phasespace(2,:)./(1+dv);
phasespace(4,:)=phasespace(4,:)./(1+dv);
 
return
    
