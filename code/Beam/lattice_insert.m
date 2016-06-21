function lattice_insert(nelem,nlattice)
% insert elem in lattice0 
% from element num nelem
% to lattice0 at nlattice
% make lattice and dynamique
global ELEMENT LATTICE0 LATTICE 

nl  =length(LATTICE0);
nlat=nl+1;             % last element of lattice  by default
if nargin==2;  nlat=nlattice; end; 

% add element
% LATTICE0(nlat).name=ELEMENT(nelem).name;
% LATTICE0(nlat).num =nelem;
% LATTICE0(nlat).div =[1 1];

ADD.name=ELEMENT(nelem).name;
ADD.num =nelem;
ADD.type=ELEMENT(nelem).type;
ADD.strength=ELEMENT(nelem).strength;
ADD.div =[1 1];


%shift by 1 from nlat
% for i=nl:-1:nlat
%     LATTICE0(i+1)=LATTICE0(i);
% end
LATTICE0(nlat+1:nl+1)=LATTICE0(nlat:nl);

% insert at nlat
LATTICE0(nlat).name=ADD.name;
LATTICE0(nlat).num =ADD.num;
LATTICE0(nlat).type=ADD.type;
LATTICE0(nlat).strength=ADD.strength;
LATTICE0(nlat).div =ADD.div;
LATTICE0(nlat).name=ADD.name;


LATTICE=LATTICE0;
% lattice_fill;
% LATTICE0=LATTICE; 

end