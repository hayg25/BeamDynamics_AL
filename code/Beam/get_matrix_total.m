function [matrix]=get_matrix_total
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return total matrix
global ELEMENT LATTICE

% 
nelem=length(LATTICE);
for i=1:nelem
    num=LATTICE(i).num;
    [T]=matrix_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div);
    matrix(i,:,:)=T;
end


