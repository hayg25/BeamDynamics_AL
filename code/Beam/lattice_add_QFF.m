function lattice_add_QFF
% Add element QFF
% Implement lattice with kick at entrance & exit of each quad
% Call Qff_pass
% warning with qpole splitted !
%lattice_beta2code;
global ELEMENT LATTICE0 

nel=length(ELEMENT);nlat=length(LATTICE0);
qff=0;
%Scan quad in LATTICE0 & create element and complet lattice0
for i=nlat:-1:1
    num=LATTICE0(i).num;
    type=ELEMENT(num).type;
    if strcmp(type,'QFF'); qff=1;break;end % Already exist
    if strcmp(type,'QP')
        %exit
        name=[ELEMENT(num).name 'FFex'];
        K=ELEMENT(num).strength;
        [nelem]=element_QFF(name,-K);
        lattice_insert(nelem,i+1)
        %entrance 
        name=[ELEMENT(num).name 'FFen'];
        K=ELEMENT(num).strength;
        [nelem]=element_QFF(name,+K);
        lattice_insert(nelem,i)
    end 
end
lattice_fill;
nel1=length(ELEMENT);nlat1=length(LATTICE0);
%
if qff==0
    fprintf('Add Qpole fringe field kick \n')
    fprintf('  ELEMENT %d  -> %d \n',nel,nel1)
    fprintf('  LATTICE %d  -> %d \n',nlat,nlat1)
else
    fprintf('Qpole fringe field kick exist \n')
end
