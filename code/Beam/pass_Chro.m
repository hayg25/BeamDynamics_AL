function [phasespace]=pass_Chro(phasespace,ksi) 
% apply QP kick pass in ring in kick approx (thin lens)
% To modelize chromaticities from elements

%
kx=ksi(1);kz=ksi(2);
if (kx~=0); phasespace(2,:)=phasespace(2,:)+kx*phasespace(1,:).*phasespace(6,:); end;
if (kz~=0); phasespace(4,:)=phasespace(4,:)+kz*phasespace(3,:).*phasespace(6,:); end; 


return
    
