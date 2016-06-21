function [gs,s_mean, s_rms, s_emit,cur,s_twiss]=bunch_statistics_slice(phasespace,qm,nbin,Nsigma,n)
% Comput mean, rms and emittance data from sliced phasespace over s (5)
% Remove dispersion correlation if disp is given
% nbin    : number of slice
% data are table of size (param,nbin)
% s_mean  : mean of the 6 variables  (6,nbin)
% s_sig   : std of the 6 variables   (6,nbin)
% s_emit  : emt of the 3 subspaces (geometric) (3,nbin)
% cur     : current (A) (1,nbin)
% s_twiss : bx ax  bz az  twiss parameter (4,nbin)

ns=5;  %default slicing over s position
if nargin<4 ; Nsigma = 4 ; end
if nargin==5; ns = n; end
%
%phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));

% get ps data
s_rms0 = std(phasespace(ns,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms0,Nsigma*s_rms0,nbin)';
% binning for the slice parameters
[A,bin] = histc(phasespace(ns,:),grille);

% Over slices
s_mean=zeros(6,nbin); s_rms=s_mean; s_q=zeros(1,nbin);
s_emit=zeros(3,nbin); s_twiss=zeros(4,nbin);
for i=1:nbin
    num_par = length(find(bin==i));
    if(num_par >= 5)
        slicephase = phasespace(:,bin==i); 
        [s_mean(:,i), s_rms(:,i), s_emit(:,i), s_q(:,i), s_twiss(:,i)]=bunch_statistics(slicephase,qm);
    end
end

% Current profil
step=(2*Nsigma*s_rms0)/nbin;
gs  =2*Nsigma*s_rms0*( (1:nbin)-nbin/2 )/nbin;
cur =s_q(:,:)/step*3e08;

return