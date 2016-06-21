function [nelem]=element_RF(name,E,Vrf,Frf,phis)
% create element RF
% Vrf in MV
% Frf in Hz
global ELEMENT DYNAMIC

nl=length(ELEMENT);
% check if name already exist
nelem=nl+1;
for i=1:nl
    nom=ELEMENT(i).name;
    if strcmp(name,nom);nelem=i;break;end
end

c=3e8;
kl=2*pi*Frf/c;
K=+kl*Vrf*sin(phis)/E;

ELEMENT(nelem).name    =name;
ELEMENT(nelem).type    ='RF';
ELEMENT(nelem).length  =0;
ELEMENT(nelem).div     =1;
ELEMENT(nelem).strength=K;

DYNAMIC.RF=[Vrf,Frf,phis];

end