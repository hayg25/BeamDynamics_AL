function [sige,corr,eps,bs,as,gs]=get_beam_long1(sigs,M)
% make beam from sigs
%
mus=acos(trace(M)/2);  % no warning if trace> 2 : instable
if M(1,2)<0;mus=-mus;end
bs = M(1,2)/sin(mus);
as =(M(1,1)-M(2,2))/sin(mus)/2;
gs =-M(2,1)/sin(mus);
% get beam size
eps  = sigs^2/bs;       % from sigs input
corr = -as/bs;          % to fit bunch generation distrib method
sige = sqrt(eps*gs - (corr*sigs)^2);


return