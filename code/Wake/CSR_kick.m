function [phasespace,grille,profil,wake,green,U]=csr_wake(phasespace,q,R,E,L)
% calcul le wake v sur la base CSR par m de dipole
% l'applique à dp en eV
% W =0 t>0
% W =-2 / (3)**0.333 / (R)**0.666  * int( df/ds /(s-s')**0.333 ) /4 pi eps0     t<= 0
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% phi distribution en position (m)
% q charge du paquet complet
% R    dipole radius m
% E  energy in MeV 
% L integration length (m)
% wake
% U mean losses

%
[profil,grille,phimin,qm,nbin,step]=get_profile(phasespace,q,5);
[wake,green] =CSR_wake(profil,grille,phimin,qm,nbin,step,R,L);
[phasespace] = get_kick(phasespace,grille2,wake,E);
return

