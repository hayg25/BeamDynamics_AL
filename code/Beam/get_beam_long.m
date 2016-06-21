function [sigs,eps,bs,as,gs]=get_beam_long(sige,M)
% make beam from sige
%
mus=acos(trace(M)/2);  % no warning if trace> 2 : instable
if M(1,2)<0;mus=-mus;end
bs =abs(M(1,2)/sin(mus));
as =(M(1,1)-M(2,2))/sin(mus)/2;
gs =abs(M(2,1)/sin(mus));
% get beam size
eps = sige^2/gs;        % from sige input        
sigs= sqrt(eps*bs);

return