function [gs,p_mean, p_rms, p_emit]=bunch_statistics_proj(phasespace,qm,nbin,Nsigma,n)
% Comput projected mean, rms and emittance data from sliced phasespace over s (5)
% Remove dispersion correlation if disp is given
% nbin    : number of slice
% data are vector of size 6
% p_mean  : mean of the 6 variables  
% p_sig   : std of the 6 variables   
% p_emit  : emt of the 3 subspaces (geometric) 

ns=5;  %default slicing over s position
if nargin<4 ; Nsigma = 4 ; end
if nargin==5; ns = n; end
[gs,s_mean, ~, ~,cur]=bunch_statistics_slice(phasespace,qm,nbin,Nsigma,5);

% Projected emittance
weight=sum(cur);
s_meanw =s_mean.*(ones(6,1)*cur)/weight;
p_mean=mean((s_meanw),2);  % The 6 means
sig   =cov(s_meanw');      % Sigma matrix 6*6
p_rms =sqrt(diag(sig));    % std of the 6 variables
% Emittances
i=1;emitx=sqrt(det(sig(i:i+1,i:i+1)));
i=3;emity=sqrt(det(sig(i:i+1,i:i+1)));
i=5;emits=sqrt(det(sig(i:i+1,i:i+1)));
p_emit=[emitx ; emity ; emits];% emittance of the 3 subspaces

return