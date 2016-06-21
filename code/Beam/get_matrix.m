function [matrix]=get_matrix
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return a table matrix(nelem , 6 , 6) with twiss parameter
global ELEMENT LATTICE

% 
nelem=length(LATTICE);
for i=1:nelem
    num=LATTICE(i).num;
    %[T]=matrix_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div);
    [T]=matrix_element(ELEMENT(num).type,ELEMENT(num).length,LATTICE(i).strength,ELEMENT(num).div);
    matrix(i,:,:)=T;
end


