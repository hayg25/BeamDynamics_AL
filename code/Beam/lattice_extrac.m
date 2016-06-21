function lattice_extrac
% extract sub lattice from lattice
% need i_start to i_end in LATTICE0
% make lATTiCe and dynamiquE 
global ELEMENT LATTICE0 LATTICE DYNAMIC

i_start=62;
i_end  =96;

% change starting data at i_start-1
DYNAMIC.twiss=LATTICE0(i_start-1).twiss;
DYNAMIC.disp =LATTICE0(i_start-1).disp;
pos0=LATTICE0(i_start-1).pos;

LATTICE01=LATTICE0(i_start:i_end);
% LATTICE0 LATTICE
LATTICE0=LATTICE01;

% restart pos to zero
nelem=length(LATTICE0);
for i=1:nelem;
    LATTICE0(i).pos=LATTICE0(i).pos-pos0;
end
LATTICE =LATTICE0;


end