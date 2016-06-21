function [profil,grille,phimin,nbin,step,sigs,pmax]=get_profile(phasespace,n,nrms)
% return profil on mesh dimension n of phasespace
% Profil is just counting, not density, have to divide by stp
global  DYNAMIC

% 
nbin=51;  % default
if isfield( DYNAMIC, 'nbin'); nbin= DYNAMIC.nbin ; end
%


% remove mean
phim=mean(phasespace(n,:));
phi=phasespace(n,:)-phim;


% mesh over length
sigs=std(phi);
phimax=6*sigs;
phimin=-phimax;
step=(phimax-phimin)/nbin;
grille=phimin:step:phimax;
nbin=length(grille);

% binnage
[profil]=hist(phi,grille);  
[profil]=smoothing(profil);

% Peak position
[peak,I]=max(profil);
pmax=phimin+phim+I*step;


return
