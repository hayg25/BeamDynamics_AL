function err_corr_set_values(MCX,MCZ,nhc,nvc,X,Z)
% solve (x1 x2 etc ) = MCX (hc1 hc2 etc ...) for each BPM
% corr values given by -inv(MCX)*(X)
% corr values applied to LATTICE element
global  LATTICE

% H planes
hc=lsqr(MCX,-X');
%hc=-MCX\X'
for i=1:length(nhc);LATTICE(nhc(i)).strength=hc(i);end

% H planes
vc=lsqr(MCZ,-Z');
for i=1:length(nvc);LATTICE(nvc(i)).strength=vc(i);end


