% Example 1
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
global  LATTICE ELEMENT
% Get matrix of element 12 in lattice
nelem=12;num=LATTICE(nelem).num;
fprintf('Matrix of element %d  type  %s\n',nelem,ELEMENT(num).name)
[T]=matrix_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div);
T


% Get total matrix M
M=eye(6);
nelem=length(LATTICE);
num=LATTICE(12).num;
for i=1:nelem
    num=LATTICE(i).num;
    [T]=matrix_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div);
    M=T*M;
end
fprintf('Matrix total over %d  elements  %d\n',nelem)
M