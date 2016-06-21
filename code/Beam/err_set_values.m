function err_set_values(ampl)
% set errors to each quad displacement only for the moment
% maybe : dx dz dteta  dk/k (db/b) ?
global  LATTICE

nel =length(LATTICE); 

for i=1:nel
    type=LATTICE(i).type;
    if strcmp(type,'QP')
        LATTICE(i).err= randn(1,3)*ampl;
    end 
end

