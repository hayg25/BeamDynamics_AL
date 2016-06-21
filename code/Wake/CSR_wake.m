function [wake,green]=CSR_wake(profil,grille,phimin,qm,nbin,step,R,L)
% calcul le wake v sur la base CSR par m de dipole
% l'applique à dp en eV
% W =0 t>0
% W =-2 / (3)**0.333 / (R)**0.666  * int( df/ds /(s-s')**0.333 ) /4 pi eps0
% t<= 0
% q charge du paquet complet
% R    dipole radius m
% L integration length (m)
% wake
% U mean losses

%
pieps=1.1e-10;  % 4 pi eps0

%
df=gradient(profil,step); 
% dprofil=df;
[dprofil]=smoothing(df);

% green on bin
ds=(grille-phimin);
A=-2/pieps/power(3,1/3)/power(R,2/3);
green=power(ds,1/3);green(1)=1;
green=A./green;green(1)=0;    % remove first term

% wake on bin by convolution  in volt
wake = conv(green,dprofil);
wake = wake(1:nbin);      % only the first half
wake =wake*qm*1e-6*L;       % in MV/m

return

