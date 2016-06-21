function [phasespace1,nloss,flag]=get_losses(phasespace,pipe,w)
% remove particles out of pipe
% pipe = limit value H & V assumed elliptic
% nloss = number of lost particles
% particles are removed (w=1) or set to zero (w=0)...

n =length(phasespace);
x=phasespace(1,:);pipex=pipe(1);
z=phasespace(3,:);pipez=pipe(2);
%
r=x.^2/pipex^2 + z.^2/pipez^2;
%
if w==1  % particle removed
    ind = find(r<1);
    phasespace1=phasespace(:,ind) ; % to remove
    n1=length(phasespace1);
    nloss=n-n1;
elseif w==0   % particle set to zero
    ind = find(r>1);
    nloss=length(ind);
    phasespace(:,ind)=zeros(6,length(ind)) ; % to set to zero
    phasespace1=phasespace;
    n1=n-nloss;
end

flag=0;
if n1<=10; flag=1; end; % total loss
    
return