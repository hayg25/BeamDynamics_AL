function [nelem]=element_SD(name,L)
% create element drift
% L drift length
global ELEMENT 

nl=length(ELEMENT);
% check if name already exist
nelem=nl+1;
for i=1:nl
    nom=ELEMENT(i).name;
    if strcmp(name,nom);nelem=i;break;end
end
%
ELEMENT(nelem).name    =name;
ELEMENT(nelem).type    ='SD';
ELEMENT(nelem).length  =L;
ELEMENT(nelem).div     =1;
ELEMENT(nelem).strength=0;

return