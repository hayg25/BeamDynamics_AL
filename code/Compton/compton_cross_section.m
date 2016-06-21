%function compton_cross_section
% plot compton_cross_section backscattering
% need : 
%   Ee   : electron energy
%   Eph  : laser pohton energy  Eph= (hc) /(lambda e)


Ee =50;      % MeV
Eph=1.23e-6;  % Mev   lambda=800 nm
El=0.025;      % joule  for puls laser  
sigx=2.9043e-05;  % rms electron beam size
Zr=0.01;
fprintf('###################### \n');
fprintf('Ee = %d MeV   Eph = %d eV   El = %d mJ\n',Ee,Eph*1.e6,El*1e3);

% constante
h =6.6e-34;
re=2.818e-15; 
q = 1.6e-19;
cl=3e8 ;
E0=0.511 ;
gam=(Ee+E0)/E0;
rad2deg=180/pi;
barn=1e-28;  % barn in m^2
lambda=h*cl/Eph/1e6/q; 

teta=0.:0.00001:0.3; % Emission angle relative to electron
X   =(teta*gam).^2;
Z   =4*Ee*Eph/E0^2;
Exmax=Ee*Z./(1+Z);  % MeV
fprintf('Max scattered photon energy = %d keV \n',Exmax*1e3);

% Ex backscattering in MeV
Ex = Ee*Z./(1+Z+X);

% Cross section dsig/dEx per scattered photon Energy Ex
a=1./(1+Z);
r=1./(1+a*X);
k=(r.^2*(1-a)^2)./(1-r.*(1-a));
c=(1-r.*(1+a))./(1-r.*(1-a));
sig=2*pi*re^2*a*(1 + k + c.^2)/Exmax; %Cross section dsig/dEx

% Mean photon energy
dEx=-[diff(Ex) 0]; % step in Ex grid
sigmean=sum(sig.*dEx);       % integral over dsig/dEx
%sigtheo=8*pi*re^2/3
fprintf('Mean cross section = %d barn \n',sigmean/barn);
Exmean=  sum(Ex.*sig.*dEx)/sigmean; % integral
fprintf('Mean scattered photon energy = %d keV \n',Exmean*1e3);

% Mean energy loss per electron
Nph=El/q/Eph*1e-6; % Number of photons
fprintf('Number of photons = %d  \n',Nph);
dE=Exmean*Nph*sigmean/pi/sigx^2; % in MeV
dE=4*sigmean*gam^2*El/(lambda*Zr)/q ;
fprintf('Mean electron energy loss = %d eV \n',dE);






% plot
figure(1)
plot(teta*rad2deg,Ex*1e+3)
xlabel('Teta (deg)')
ylabel('Backscattered photon energy (KeV)')
title([num2str(Ee) ' MeV Electron versus ' num2str(Eph*1e6) ' eV Laser'])
grid on


figure(2)
plot(Ex*1e+3,sig/barn)
xlabel('Backscattered photon energy (KeV)')
ylabel('Backscattered diffrential cross section  (b/MeV)')
title([num2str(Ee) ' MeV Electron versus ' num2str(Eph*1e6) ' eV Laser'])
grid on









