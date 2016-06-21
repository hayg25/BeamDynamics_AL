function [phasespace,U] = get_kick(phasespace,grille,wake,E)
% Interpole over particles on wake
% wake
% U mean losses
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% phi distribution en position (m)

phi=phasespace(5,:);phi=phi-mean(phi);
dp = interp1(grille,wake,phi,'spline',0);
%dp = interp1q(grille',wake',phi'); % supposed to be faster?
U=-mean(dp);  
phasespace(6,:)=phasespace(6,:)+dp/E;           %relative energy variation
% % Transverse damping (idem with RF pass)
% phasespace(2,:)=phasespace(2,:)./(1+dp/E);
% phasespace(4,:)=phasespace(4,:)./(1+dp/E);
return
