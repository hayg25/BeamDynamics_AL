function lattice_add_QPmult(mult)
% Add thin lens multipole on quad
% mult=[npole/2  db/b  radius]
% Implement lattice with kick at entrance & exit of each quad
% Call Multipole_pass
% Warning with qpole splitted !
% lattice_beta2code;
global ELEMENT LATTICE0

np =mult(1);
db =mult(2);
rd =mult(3);

nel=length(ELEMENT);nlat=length(LATTICE0);

%Scan quad in LATTICE0 & create element and complet lattice0
for i=nlat:-1:1
    num=LATTICE0(i).num;
    type=ELEMENT(num).type;
    if strcmp(type,'QP')
        name=[ELEMENT(num).name num2str(2*np) 'pole'];
        K=LATTICE0(i).strength;
        L=LATTICE0(i).length;
        Kn=db*K*L/power(rd,np-2);
        [nelem]=element_multipole(name,[np Kn/2]);
        %exit
        lattice_insert(nelem,i+1)
        %entrance 
        lattice_insert(nelem,i)
    end 
end
lattice_fill;
nel1=length(ELEMENT);nlat1=length(LATTICE0);
%

fprintf('Add QP multipole kick \n')
fprintf('  ELEMENT %d  -> %d \n',nel,nel1)
fprintf('  LATTICE %d  -> %d \n',nlat,nlat1)

