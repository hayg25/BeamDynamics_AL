function lattice_remove(nlattice)
% insert elem in lattice 
% from element num nelem
% to lattice at nlattice
% make lATTiCe and dynamiquE 
global ELEMENT LATTICE0 LATTICE 

nlat=length(LATTICE0)   ; % last element of lattice  by default
if nargin==1;  nlat=nlattice; end; 

% remove element nlat
LATTICE0(nlat).name=ELEMENT(nelem).name;
LATTICE0(nlat).num =nelem;
LATTICE0(nlat).div =[1 1];

LATTICE=LATTICE0;
lattice_fill;
LATTICE0=LATTICE; 

end