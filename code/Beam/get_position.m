function [pos]=get_position
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return a table pos with position and length of element
% return a table div
global ELEMENT LATTICE 
%
L=0;
% 
nelem=length(LATTICE);
for i=1:nelem
    num=LATTICE(i).num;
    div=ELEMENT(num).div;
    lenght=(ELEMENT(num).length)/div;
    L=L+lenght;
    pos(i,:)=[lenght L];     
end


