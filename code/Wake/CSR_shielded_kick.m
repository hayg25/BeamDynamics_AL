function [phasespace,grille,profil,wake,green,U,r]=CSR_shielded_kick(phasespace,q,R,h,E,L)
% calcul le wake v sur la base CSR Murphy,Krinsky,Gluckstern + Debernev
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
% h half heigth pipe
% r<0.02 no shielding  r>10 full shielding

% warning : a circshift added to prevent
% from positive main energy over the bunch
% energy gain !
% = wake_s=circshift(wake_s,[0 -1]); %added

%

[profil,grille,phimin,qm,nbin,step,sigs]=get_profile(phasespace,q,5);
[wake,green,r]=CSR_shielded_wake(profil,grille,phimin,qm,nbin,step,sigs,R,h,L);
[phasespace,U] = get_kick(phasespace,grille,wake,E);

return