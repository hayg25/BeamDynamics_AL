function [P,Ec,w,wn,fn,En]=SR_spectral_power(E,B,xx)
% for radiation profil
% E energy in MeV
% B field in tesla
% xx : power frequency range in w/wc : ex.[-10 : 0.05 : 1]

% P  : Spectral power dP/dw (eV/turn/frequency) (CAS fift general p.448)
% Ec : charcteristic dipole energy in eV 
% w  : in rad/s
% wn : wave number in m-1
% f  : freq in Hertz
% E  : in eV


E0  =0.511;
gam =(E+E0)/E0;
c=3e8;
R=0.33/100*E/B;
wc=3*gam^3*c/2/R;
U0=2.65e4*(E/1000)^3*B; % SR mean loss per turn
Ec=wc/(2*pi*c)*1.23/1e6;

% Get dP/dw from SR
A=9*sqrt(3)/8/pi;
% integeral over log abcisse (better)
xx=power(10,xx); % w/wc
dim=length(xx);
K53=besselk(5/3,xx);
t  =cumsum(-K53(dim-1:-1:1).*diff(xx(dim:-1:1)));
xx=xx(1:dim-1);
t  =t(dim-1:-1:1).*xx;
S  =A*t;   % ordered versus w/wc
P  =U0/wc*S;   

w=xx.*wc;           % in rad/s
wn= w/(2*pi*c);     % wave number in m-1
fn=w/(2*pi);         % freq in Hertz
En=wn*1.23/1e6;      % in eV


% figure(1)
% loglog(E,P,'--b');hold on
% %ylim([0.1 1e20])
% grid on ;ylabel('dP/dw');
% xlabel(' E (eV) ')



return

% integral over linear abcisse (not very good)
% xmin=1e-4;dx=1e-4;xmax=10;
% xx=[xmin : dx : xmax];  %w/wc
% K53=besselk(5/3,xx);
% dim=length(xx);
% t  =cumsum(K53(dim:-1:1))*dx;
% t  =t(dim:-1:1).*xx;
% P  =A*t;              % ordered versus w/wc

%ratio=8*pi*0.33/195.7/(3*per_ond*(1+K^2/2)*B)  % w-ond/wc
% Get the G(w) function (CSR form factor) from numerical profil
%[phasespace]=bunch_generation(twiss,disp,eps,long,np);
% [profil,nbin,grille,step,phimin,phimax]=get_binning(phasespace,5);
% X = ifft(profil/sqrt(np));
% G = abs(X).^2;G=G(1:nbin/2);
% w = 2*pi*[1:nbin/2]/nbin/step*c; % rad/s
% f = w/(2*pi)/1e12; % freq in teraherz
% wn= w/(2*pi*c)/100; % wave number in cm-1


