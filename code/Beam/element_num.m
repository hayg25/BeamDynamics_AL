function [nelem]=element_num(name)
% find pos of name in the lattice

global  LATTICE
nel =length(LATTICE); 
k=0;
for i=1:nel
    nom=LATTICE(i).name;
    if strcmp(nom,name);k=k+1;nelem(k)=i;end % corr H
end


