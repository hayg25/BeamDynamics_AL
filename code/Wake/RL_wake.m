function [wake]=RL_wake(profil,qm,step,Rr,Li,fc)
% calcul le wake v sur la base resistif + inductif model
% wake = Rr * lambda + Li * d(lambda)/dt  : lambda in A   wake in eV/m
% Rr in Ohm
% Li in Henri
% E  energy in MeV 
% fc Freq cut in Hz
% wake

%
c=3e8;  % light speed

% Case we want to remove high freq in the model
if nargin == 6 ;
    nbin=length(profil);
    fmax =3e8/step;
    nc   =floor(nbin/(fmax/fc));% get cut
    if nc==0 % Complet cut : force to zero
       wake=ones(1,nbin)*0;
       return
    end
end

% 
profil1 =profil*qm/step;
dprofil=gradient(profil1,step);
[dprofil]=smoothing(dprofil);
% profil  in Q/m      I    = profil*c    in A
% dprofil in Q/m^2    dI/dt= dprofil*c^2 in A/s

% wake
wake = -c*(Rr*profil1 - Li*dprofil*c)*1e-6;       %in MV/m

% Fourier high freq cut on the wake
if nargin == 6 ;
    Iw=fft(wake);
    Iw(nc:nbin-nc)=0;
    wake=real(ifft(Iw)); 
end

return

