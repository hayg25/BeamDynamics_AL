function [nelem]=lattice_index(name,type)
% find pos of name in the lattice
% over field name by default
% over field type if nargin=2

global  LATTICE
nel =length(LATTICE);
k=0;
if nargin==1
    for i=1:nel
        nom=LATTICE(i).name;
        if strcmp(nom,name);k=k+1;nelem(k)=i;end % corr H
    end
elseif nargin==2
    for i=1:nel
        nom=LATTICE(i).type;
        if strcmp(nom,name);k=k+1;nelem(k)=i;end % corr H
    end
end


