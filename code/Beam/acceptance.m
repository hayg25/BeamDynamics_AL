function [phasespace1]=acceptance(phasespace,n,maximum,~)
% remove particles out of acceptance
% n:1=x  2=xp   3=z   4=zp  5=s   6=de/e 
% maximum = limit value in abs
% If nargin=4 : recentre phasespace

if nargin==4
    mm=mean(phasespace(n,:));
    phasespace(n,:)=phasespace(n,:)-mm; % remove mean
end
    
maximum=abs(maximum);
ind = find(abs(phasespace(n,:))<maximum);
phasespace1=phasespace(:,ind) ;

if nargin==4
    phasespace1(n,:)=phasespace1(n,:)+mm; % restore mean
end

return