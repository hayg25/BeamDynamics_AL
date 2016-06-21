function [phasespace]=pass_SX(phasespace,S) 
% apply SX pass in ring in kick approx (thin lens)
% S : normalized strength * length

%
S=S./(1+phasespace(6,:));
phasespace(2,:)=phasespace(2,:) -  S.*(phasespace(1,:).^2 - phasespace(3,:).^2);
phasespace(4,:)=phasespace(4,:) +2*S.*phasespace(1,:).*phasespace(3,:);


return
    
