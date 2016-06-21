function [phasespace,grille,profil,wake,U]=RL_kick(phasespace,q,Rr,Li,E)
% calcul le wake v sur la base resistif + inductif model
% wake = Rr * lambda + Li * d(lambda)/dt  : lambda in A   wake in eV/m
% Rr in Ohm
% Li in Henri
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% l'applique à dp en eV
% phi distribution en position (m)
% q charge du paquet complet
% E  energy in MeV 
% L integration length (m)
% wake
% U mean losses

%

[profil,grille,phimin,qm,nbin,step]=get_profile(phasespace,q,5);
[wake]=RL_wake(profil,qm,step,Rr,Li);
[phasespace,U] = get_kick(phasespace,grille,wake,E);

return

