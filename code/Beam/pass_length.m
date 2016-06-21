function [phasespace]=pass_length(phasespace,L) 
% apply delay pass induced by angles (x',z')
% ds=-0.5*L*(x'2 + z'2)

%
ds=0.5*L*(phasespace(2,:).^2+phasespace(4,:).^2);
phasespace(5,:)=phasespace(5,:)-ds;



return
    
