function [phasespace]=bunch_density_modulator(phasespace,r,lambda,sig)
% simple energy modulator
% dE relative amplitude
% lambda : periode in meter
% sig : rms length of modulation

km=2*pi/lambda;
s=phasespace(5,:);
d=sin(km*s);

% Gaussian amplitude modulation
if (nargin==4);d=d.*exp(-0.5*s.^2/sig/sig);end

%
phasespace(5,:)=phasespace(5,:)-d/km*r;


return
% Make density modulation
phasespace(5,:)=phasespace(5,:)-phasespace(6,:)/dE/km;
% Remove energie modulation
phasespace(6,:)=phasespace(6,:)-d;


return