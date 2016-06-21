function [phasespace]=bunch_energy_modulator(phasespace,dE,lambda,sig)
% simple energy modulator
% dE relative amplitude
% lambda : periode in meter
% sig : rms length of modulation

km=2*pi/lambda;
s=phasespace(5,:);
d=dE.*sin(km*s);

% Constant modulation
if (nargin==3)
    phasespace(6,:)=phasespace(6,:)+d;
end

% Gaussian amplitude modulation
if (nargin==4)
    d=d.*exp(-0.5*s.^2/sig/sig);
    phasespace(6,:)=phasespace(6,:)+d;
end