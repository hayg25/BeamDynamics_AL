function lattice_step_QP_1(dk,name)
% Step quad strength by K*1+dk)
% with out name : all quad
% on LATTICE directly
global   LATTICE DYNAMIC

elem_name='All';
if nargin==0; return ; end
if nargin==2; elem_name=name ; end
    
% Step the QP strength
nel =length(LATTICE);
if (strcmp(elem_name,'All'))
    for i=1:nel
        type=LATTICE(i).type;
        if strcmp(type,'QP')
            LATTICE(i).strength=LATTICE(i).strength*(1+dk);
            LATTICE(i).matrix=matrix_quad(LATTICE(i).length,LATTICE(i).strength);
        end
    end
else
    for i=1:nel
        type=LATTICE(i).type;
        nom =LATTICE(i).name;
        if strcmp(type,'QP') && strcmp(nom,elem_name)
            LATTICE(i).strength=LATTICE(i).strength*(1+dk);
            LATTICE(i).matrix=matrix_quad(LATTICE(i).length,LATTICE(i).strength);
        end
    end
end

% Complet the LATTICE structure
twiss0=DYNAMIC.twiss;%input
disp0=DYNAMIC.disp ;%input
M=eye(6);
for i=1:length(LATTICE)
    T=LATTICE(i).matrix;
    M=T*M;
    LATTICE(i).twiss=M*twiss0*M';
    LATTICE(i).disp=M*disp0;
end
DYNAMIC.matrix=M;

end