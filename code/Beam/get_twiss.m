function [twiss]=get_twiss
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return a table twiss(nelem , 6 , 6) with twiss parameter
global ELEMENT LATTICE DYNAMIC
%
twiss0=DYNAMIC.twiss ;%input
% 
M=eye(6);nelem=length(LATTICE);
twiss=zeros(nelem,6,6);
for i=1:nelem
    num     =LATTICE(i).num;
    type    =ELEMENT(num).type;
    len     =ELEMENT(num).length;
    %strength=ELEMENT(num).strength;
    strength=LATTICE(i).strength;
    div     =ELEMENT(num).div;
    [T]=matrix_element(type,len,strength,div);
    M=T*M;
    twiss(i,:,:)=M*twiss0*M';
end


