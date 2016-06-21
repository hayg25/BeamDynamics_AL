function [phasespace]=bunch_generation_gun(phasespace,E,E0,Frf,phi,q,L) 
% Modelise bunch from gun & linac
% mainly shape by RF curvatur
% and mean LSC
% Frf : linac frequency in Hz
% E : max energy (MeV)
% E0 rest mass   (MeV)
% q charge nC
% ds phase in m   0 = max acceleration on crest
% L linac length

% % sige analytique courbure RF second ordre
% kl=2*pi*Frf/c;
% sige=kl*sigs*sqrt((sin(kl*ds)^2 + 0.5*(kl*sigs)^2*cos(kl*ds))) 

%
c=3e8;
kl=2*pi*Frf/c;
ds =phi/kl;

%
Egun=E*phasespace(6,:)  +  E*cos(kl*(phasespace(5,:) - ds ));
Emean=mean(Egun);
Egun=Egun*E/Emean;  % restore mean energy to E
phasespace(6,:) = (Egun-E)/E;

% add a mean LSC effect
% replace max E by sqrt(E0*Emax)
%[phasespace,grille,profil,wake_lsc,green]=lsc_wake(phasespace,q,E,E0,10);

return
    
