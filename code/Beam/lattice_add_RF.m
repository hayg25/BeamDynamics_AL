function lattice_add_RF(name,E,V,Freq,phase,nlattice)
% name = nom
% E = energie in MeV
% V = voltage in MV
% Freq= frequency in Hz
% phase= = phase in radian
% nlattice = localisaion
global ELEMENT LATTICE0 

nel=length(ELEMENT);nlat=length(LATTICE0);
%
nelem=element_RF(name,E,V,Freq,phase); % new element / break if alraedy exist
lattice_insert(nelem,nlattice);
lattice_fill;
% add at end of lattice
nel1=length(ELEMENT);nlat1=length(LATTICE0);
%
fprintf('ELEMENT %d  -> %d \n',nel,nel1)
fprintf('LATTICE %d  -> %d \n',nlat,nlat1)

end