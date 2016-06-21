function [phasespace,grille,profil,wake,green,U]=LSC_kick(phasespace,q,E,E0,L)
% calcul le wake space 1D longitudinal
% l'applique à dp en eV charge longitudinal
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% phi distribution en position (m)
% q charge du paquet complet
% wake  1\r^2
% W =0 t>0
% E  energy in MeV 
% E0  rest mass
% L integration length (m)
% U mean losses

%
[profil,grille,phimin,qm,nbin]=get_profile(phasespace,q,5);
[wake,green]=LSC_wake(profil,grille,phimin,qm,nbin,E,E0,L);
[phasespace,U] = get_kick(phasespace,grille,wake,E);
return

