function [phasespace,e0,q0,qm]=phasespace_astra2code(file)
% get astra phasespace output
% convert unit and order
% astra : x    y   z-z0   px     py  pz-pz0    ( m ev/c )
% code  : x  px/p  y   py/p   z   de/e      ( m rad )

fid = fopen(file);



% 1nd line is reference particle
    reference = fscanf(fid,'%e %e %e %e %e %e %e %e %e %e \n',[10 1]);
    ct = reference(7)*0.299792458 ; %c in m/ns
   
    % take gammag from momentum of reference particle
    p0 = reference(6);
    e0 =(sqrt(p0^2 + 511000^2) - 511000)*1e-6;
    %gammag=(e0+0.511)/0.511;
    % phasespace 
    phasespace = fscanf(fid,'%e %e %e %e %e %e %e %e %e %e',[10 inf])';
    %store=[phasespace(:,7) phasespace(:,9) phasespace(:,10)];
    qm=abs(phasespace(1,8)*10^-9);
    q0=abs(sum(phasespace(:,8))*10^-9);
%     % shuffle phasespace 
%     phasespace = [  phasespace(:,1)-reference(1)  (phasespace(:,4)-reference(4))/p0  phasespace(:,2)-reference(2)    ...
%                     (phasespace(:,5)-reference(5))/p0  phasespace(:,3)   (phasespace(:,6))/p0 ];
                
    p=sqrt(phasespace(:,4).^2 + phasespace(:,5).^2 + (phasespace(:,6)+p0).^2);
    phasespace = [  phasespace(:,1)+reference(1)  (phasespace(:,4)+reference(4))./p  phasespace(:,2)+reference(2)    ...
                    (phasespace(:,5)+reference(5))./p  phasespace(:,3)   (p-p0)./p0 ];
                
    % normalize charge distribution to 1, store total charge
    phasespace=phasespace';
    
    p0
    mean(phasespace(:,6))
    
fclose(fid);
