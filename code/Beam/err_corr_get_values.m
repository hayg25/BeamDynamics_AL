function [hc, vc]=err_corr_get_values(MCX,MCZ,X,Z)
% solve (x1 x2 etc ) = MCX (hc1 hc2 etc ...) for each BPM
% corr values given by -inv(MCX)*(X)
% corr values (hc vc) not applied to LATTICE (radian)

% H planes
hc=lsqr(MCX,-X');

% H planes
vc=lsqr(MCZ,-Z');


