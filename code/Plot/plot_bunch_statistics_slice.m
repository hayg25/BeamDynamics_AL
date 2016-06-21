function plot_bunch_statistics_slice(phasespace,qm,nbin,Nsigma)
% Comput mean, rms and emittance data from sliced phasespace over s (5)
% Remove dispersion correlation if disp is given
% nbin    : number of slice
% data are table of size (param,nbin)
% s_mean  : mean of the 6 variables  (6,nbin)
% s_sig   : std of the 6 variables   (6,nbin)
% s_emit  : emt of the 3 subspaces (geometric) (3,nbin)
% cur     : current (A) (1,nbin)
% s_twiss : bx ax  bz az  twiss parameter (4,nbin)
% and plot the slice

if nargin<4 ; Nsigma = 4 ; end
%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));

% get ps data
s_rms0 = std(phasespace(5,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms0,Nsigma*s_rms0,nbin)';
% binning for the slice parameters
[A,bin] = histc(phasespace(5,:),grille);

% Over slice i at centre ....
i=floor(nbin/2)+16;
num_par = length(find(bin==i));
if(num_par >= 5)
    slicephase = phasespace(:,find(bin==i));
    %[s_mean(:,i) s_rms(:,i) s_emit(:,i), s_q(:,i), s_twiss(:,i)]=bunch_statistics(slicephase,qm);
    % scatter ~centrale slice
    color=slicephase(6,:)*100;
    figure(400)
    scatter(slicephase(1,:)*1e3,slicephase(3,:)*1e3,30,color,'.')
    xlabel('X (mm)');ylabel('Z (mm)');grid on
    colorbar
    set(gca,'FontSize',16)
end

Nsig=4;
figure(600)
ncolor=128;
set(gcf,'colormap',[])
% X Z plane
% Mesh over X
phi1=slicephase(1,:);
phimax1=Nsig*std(phi1);
% Mesh over Z
phi3=slicephase(3,:);
phimax3=Nsig*std(phi3);
%
step1=(2*phimax1)/nbin;
grille1=(-phimax1:step1:phimax1) + mean(phi1);
step3=(2*phimax3)/nbin;
grille3=(-phimax3:step3:phimax3) + mean(phi3);
% imported from the net
[CXZ] = hist2(phi1,phi3,grille1,grille3);
ng=length(grille1);CXZ(1,:)=0;CXZ(ng+2,:)=0;CXZ(:,1)=0;CXZ(:,ng+2)=0;
b=2;h=ones(b)/b^2;
CXZ=filter2(h,CXZ);
mm=floor(max(max(CXZ+1))); % to fit color map
CXZ=CXZ*ncolor/mm;
CmapXZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapXZ(1,:)=1;  % force background to white
set(gca,'FontSize',16)
image(grille1*1e3,grille3*1e3,CXZ)
colormap(CmapXZ)
set(gca,'YDir','normal')
%xlim([-1  1])
xlabel('X (mm)');ylabel('Z (mm)'); grid on;
grid on

return