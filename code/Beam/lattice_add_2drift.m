function lattice_add_2drift(L)
% Add element drift L apart each quad : SDFF
% Special for fringe field evaluation on optic
% Implement lattice 
% warning with qpole splitted !

global ELEMENT LATTICE0 

if nargin == 0 ; L=0; end

nel=length(ELEMENT);nlat=length(LATTICE0);

name='SDFF';
[nelem]=element_SD(name,L);


qff=0;
%Scan quad in LATTICE0 & create element and complet lattice0
for i=nlat:-1:1
    num=LATTICE0(i).num;
    type=ELEMENT(num).type;
    name=ELEMENT(num).name;
    if strcmp(name,'SDFF'); qff=1;break;end % Already exist
    if strcmp(type,'QP')
        %exit
        lattice_insert(nelem,i+1)
        %entrance 
        lattice_insert(nelem,i)
    end 
end
lattice_fill;
nel1=length(ELEMENT);nlat1=length(LATTICE0);
%
if qff==0
    fprintf('Add null drift apart quad \n')
    fprintf('  ELEMENT %d  -> %d \n',nel,nel1)
    fprintf('  LATTICE %d  -> %d \n',nlat,nlat1)
else
    fprintf('nul drift exist  \n')
end
