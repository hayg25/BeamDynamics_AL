function [nelem]=element_QFF(name,K)
% create element QFF
% K quad strength
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
ELEMENT(nelem).type    ='QFF';
ELEMENT(nelem).length  =0;
ELEMENT(nelem).div     =1;
ELEMENT(nelem).strength=K;

return