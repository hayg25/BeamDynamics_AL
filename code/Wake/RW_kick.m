function [phasespace,grille,profil,wake,green,U]=RW_kick(phasespace,q,sig,b,E,L)
% Calcul le wake Resisitiv wall sur la base K Banes et M. Sand
% model valid pour faiscseau court aussi
% sig : conductivity  (1.4e6)
% b half beam radius or height
% L pipe lenght
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

%

[profil,grille,phimin,qm,nbin,step]=get_profile(phasespace,q,5);
[wake,green]=RW_wake(profil,grille,phimin,qm,nbin,step,sig,b,L);
[phasespace,U] = get_kick(phasespace,grille,wake,E);


return




