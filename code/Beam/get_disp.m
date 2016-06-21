function [disp]=get_disp
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC
% return a table twiss(nelem , 6 , 6) with twiss parameter
global ELEMENT LATTICE DYNAMIC
%
disp0=DYNAMIC.disp ;%input
%
M=eye(6);nelem=length(LATTICE);
disp=zeros(nelem,6);
for i=1:nelem
    num     =LATTICE(i).num;
    type    =ELEMENT(num).type;
    len     =ELEMENT(num).length;
    %strength=ELEMENT(num).strength;
    strength=LATTICE(i).strength;
    div     =ELEMENT(num).div;
    if strcmp(type,'RF');
        T=eye(6);        % remove RF for dispersion function
    else
        [T]=matrix_element(type,len,strength,div);
    end
    M=T*M;
    disp(i,:)=M*disp0;
end

