function [sigs,sige,corr,eps,bs,as,gs]=get_beam_long3(eps,M)
% make beam from eps with correlation
%
mus=acos(trace(M)/2);  % no warning if trace> 2 : instable
if M(1,2)<0;mus=-mus;end
bs =abs(M(1,2)/sin(mus));
as =(M(1,1)-M(2,2))/sin(mus)/2;
gs =abs(M(2,1)/sin(mus));
% get beam size
corr=-as/bs;% to fit bunch generation distrib method
sigs= sqrt(eps*bs);
sige = sqrt(eps*gs - (corr*sigs)^2); % remove correlation

return