function [phasespace2]=acceptanceE(phasespace,n,w)
% remove particles out of energy acceptance in absolut (LWFA)
% n:1=x  2=xp   3=z   4=zp  5=s   6=de/e 
% w = [min  max] in eV
% n=6

min=abs(w(1));
ind = find(abs(phasespace(n,:))>min);
phasespace1=phasespace(:,ind) ;

max=abs(w(2));
ind = find(abs(phasespace1(n,:))<max);
phasespace2=phasespace1(:,ind) ;

return