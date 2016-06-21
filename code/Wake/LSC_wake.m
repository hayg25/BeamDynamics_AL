function [wake,green]=LSC_wake(profil,grille,phimin,qm,nbin,E,E0,L,phasespace)
% calcul le wake space 1D longitudinal
% l'applique à dp en eV charge longitudinal
% phasespace : relative coordinates
% wake  1\r^2
% W =0 t>0
% E  energy in MeV 
% E0  rest mass
% L integration length (m)
% seems to diverge with large number of bins !
% might use L approach instead ...

%
gam=(E+E0)/E0;
Z0=376.73;
c=3e8;

if    nargin == 9
% From basic SC long impedance approx (A. Chao book instabilities)
% including beam rms size 
   a=0.5*(std(phasespace(1,:)) +  std(phasespace(3,:)));
   b=gam*std(phasespace(5,:));
   Li=-L*Z0/4/pi/c/gam^2*(1+log(b/a));
elseif nargin == 8
% From basic SC long impedance approx (A. Chao book instabilities)
% No transverse size included
   Li=-L*Z0/2/c/gam^2;
end


step=grille(2)-grille(1);
[wake]=RL_wake(profil,qm,step,0,Li);
green=grille*0;


return

% % green on bin
% pieps=1.1e-10;  % 4 pi eps0 
% ds=(grille-phimin);
% A=-1/pieps;
% 
% %green=power(ds*gam,2);green(1)=1;  % gam factor for relativistic particles
% %green=A./green;green(1)=0;         % remove first term
% 
% r=power((ds.^2+(5e-4/20)^2),3/2);   %(A. Chao book instabilities)
% green=ds./r/gam^2;
% green=A.*green;
% 
% % wake on bin by convolution  in volt/m
% wake1 = conv(green,profil) ;wake1 = wake1(1:nbin);       % first side
% profil2=profil(nbin:-1:1);                               % reverse profil
% wake2 = conv(green,profil2);wake2 = wake2(1:nbin);       % second side
% wake  = wake2(nbin:-1:1)-wake1;                          % sum up 
% wake  = (wake)*qm;   
% %  smooth again
% %[wake]=smoothing(wake);
% wake =wake*L*1e-6;                                         %in MV/m
% 
% return
% 
