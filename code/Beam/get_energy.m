function [energ]=get_energy
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return a table energ with exit energy for each element
% implement strength with input E for cavity element

global ELEMENT LATTICE DYNAMIC
%
E   =DYNAMIC.energy;% from input
% 
nelem=length(LATTICE);
for i=1:nelem
    dE=0;
    num=LATTICE(i).num;
    div=ELEMENT(num).div;
    T=LATTICE(i).type;
    if strcmp('CH',T); 
        strength=LATTICE(i).strength;
        L=ELEMENT(num).length/div;
        dE=L*strength(2);
        strength(1)=E;
        LATTICE(i).strength=strength;
        E=E+dE;
    end
    energ(i,:)=[E dE];     
end


