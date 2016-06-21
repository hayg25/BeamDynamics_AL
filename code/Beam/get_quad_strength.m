function [KQP GQP L0]=get_quad_strength
% get QP strength
global LATTICE0 

nl  =length(LATTICE0);
% 
j=0;
for i=1:nl
    
    name=LATTICE0(i).name;
    type=LATTICE0(i).type;
    K   =LATTICE0(i).strength;
    L   =LATTICE0(i).length;
    E   =LATTICE0(i).energy;
    
    if strcmp(type,'QP') 
        j=j+1;
        KQP(j)=K; 
        GQP(j)=K*3.3356e-3*E(1);
        L0(j) =L;
    end

end


