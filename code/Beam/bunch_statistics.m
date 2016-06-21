function [b_mean, b_sig, b_emit,q,b_twiss]=bunch_statistics(phasespace,qm,disp)
% Comput mean, rms and emittance data from phasespace
% Remove dispersion correlation if disp is given
% b_mean  : mean of the 6 variables
% b_sig   : std of the 6 variables
% b_emit  : emt of the 3 subspaces (geometric)
% q       : charge in C
% b_twiss : bx ax  bz az  twiss parameter

if nargin==3  % remove dispersion correlation for x,xp z zp
    phasespace(1:4,:)=phasespace(1:4,:) - disp(1:4)*phasespace(6,:);
end


%charge
q=length(phasespace(1,:))*qm;

% mean , orbits
mx =mean(phasespace(1,:));
mxp=mean(phasespace(2,:));
my =mean(phasespace(3,:));
myp=mean(phasespace(4,:));
ms =mean(phasespace(5,:));
me =mean(phasespace(6,:));
b_mean=[mx ; mxp ; my ; myp ; ms ; me];

% diff between px/p0 and px/pz
% xp=phasespace(2,:);
% zp=phasespace(4,:);
% d =phasespace(6,:);
% dd  =sqrt((1+d).^2-xp.^2-zp.^2);
% phasespace(2,:)=phasespace(2,:)./dd;
% phasespace(4,:)=phasespace(4,:)./dd;

% std
sig =cov(phasespace(:,:)'); % Sigma matrix 6*6
b_sig =sqrt(diag(sig));     % std of the 6 variables


% emittances
i=1;emitx=sqrt(det(sig(i:i+1,i:i+1)));
i=3;emity=sqrt(det(sig(i:i+1,i:i+1)));
i=5;emits=sqrt(det(sig(i:i+1,i:i+1)));
b_emit=[emitx ; emity ; emits];% emittance of the 3 subspaces


% Twiss for H and V - planes : bx ax  bz az
b_twiss=[sig(1,1:2)/emitx sig(3,3:4)/emity]';

return