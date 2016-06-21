function [phasespace,grille,profil,wake,green,U]=BB_kick(phasespace,q,BB,E)
% calcul le wake v sur la base d'une liste broad band resonator
% BB(1,:) =Rs
% BB(2,:) =Q
% BB(3,:) =fr
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% l'applique à dp
% ws distribution liss�
% wake = wakefield on grid
% edges grille distrib wake
% U mean losses

%
[profil,grille,phimin,qm,nbin]=get_profile(phasespace,5);
[wake,green]=BB_wake(profil,grille,phimin,qm,nbin,BB);
[phasespace] = get_kick(phasespace,grille,wake,E);

return

