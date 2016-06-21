function [ G, w ,f ,wn, En, Gg ] = CSR_form_factor( profil,nbin,step,np,sigs )
%CSR_FORM_FACTOR Summary of this function goes here
% Get the G(w) function (CSR form factor) from numerical profil

c=3e8;
% case real profil
X = ifft(profil/sqrt(np));
G = abs(X).^2;G=G(1:nbin/2);
w = 2*pi*[1:nbin/2]/nbin/step*c; % rad/s
f = w/(2*pi)/1e12; % freq in teraherz
wn= w/(2*pi*c);    % wave number in m-1
En=wn*1.23/1e6;

% Case pure gaussian sigs rms (m)
sigw=c/sigs/sqrt(2);
Gg=exp(-0.5*(w/sigw).^2);

return