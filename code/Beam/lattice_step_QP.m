function lattice_step_QP(dk,name)
% Step quad strength by K*1+dk)
% with out name : all quad
global   ELEMENT

elem_name='All';
if nargin==0; return ; end
if nargin==2; elem_name=name ; end
    
% Step the QP strength
nel =length(ELEMENT);
if (strcmp(elem_name,'All'))
    for i=1:nel
        type=ELEMENT(i).type;
        if strcmp(type,'QP')
            ELEMENT(i).strength=ELEMENT(i).strength*(1+dk);
        end
    end
else
    for i=1:nel
        type=ELEMENT(i).type;
        nom =ELEMENT(i).name;
        if strcmp(type,'QP') && strcmp(nom,elem_name)
            ELEMENT(i).strength=ELEMENT(i).strength*(1+dk);
        end
    end
end
lattice_fill;

end