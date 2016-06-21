function [profil,nbin,grille,step,phimin,phimax]=get_binning(phasespace,n)
% return profil on mesh dimension n of phasespace
global  DYNAMIC

% 
nbin=50;  % default
if isfield( DYNAMIC, 'nbin'); nbin= DYNAMIC.nbin ; end

%
phi=phasespace(n,:);
phi=phi-mean(phi);

% mesh over length
phimax=6*std(phi);
phimin=-phimax;
step=(phimax-phimin)/nbin;
grille=phimin:step:phimax;
nbin=length(grille);

% binnage
[profil,bin]=hist(phi,grille);  
[profil]=smoothing(profil);

return
