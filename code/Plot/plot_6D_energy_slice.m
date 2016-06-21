function plot_6D_energy_slice(phasespace,qm,E,nbin,Nsigma)
% Comput mean, rms and emittance data from sliced phasespace over s (5)
% Remove dispersion correlation if disp is given
% nbin    : number of slice
% data are table of size (param,nbin)
% s_mean  : mean of the 6 variables  (6,nbin)
% s_sig   : std of the 6 variables   (6,nbin)
% s_emit  : emt of the 3 subspaces (geometric) (3,nbin)
% cur     : current (A) (1,nbin)
% s_twiss : bx ax  bz az  twiss parameter (4,nbin)

E0=0.511;
gam =(E+E0)/E0;

if nargin<4 ; Nsigma = 4 ; end
%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));

% get ps data
s_rms0 = std(phasespace(6,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms0,Nsigma*s_rms0,nbin+1)';
% binning for the slice parameters
[A,bin] = histc(phasespace(6,:),grille);

% Over slices
s_mean=zeros(6,nbin); s_rms=s_mean; s_q=zeros(1,nbin);
s_emit=zeros(3,nbin); s_twiss=zeros(4,nbin);
for i=1:nbin
    num_par = length(find(bin==i));
    if(num_par >= 5)
        slicephase = phasespace(:,find(bin==i));
        [s_mean(:,i) s_rms(:,i) s_emit(:,i), s_q(:,i), s_twiss(:,i)]=bunch_statistics(slicephase,qm);
    end
end

step=(2*Nsigma*s_rms0)/nbin;
gs  =2*Nsigma*s_rms0*( (1:nbin)-nbin/2 )/nbin;
cur =s_q(:,:)/step*3e08;


figure(1)
set(gca,'FontSize',16)
plot(gs,s_emit(1,:)*gam,'-r');hold on
plot(gs,s_emit(2,:)*gam,'-b');hold off
xlabel('Delta (%)'); ylabel('Emit norm. (m.rad)');
title('Energy-slice emittances')
grid on

figure(2)
set(gca,'FontSize',16)
plot(gs,s_mean(1,:)*1e3,'-r');hold on
plot(gs,s_mean(3,:)*1e3,'-b');hold off
xlabel('Delta (%)'); ylabel('X,Z (mm)');
title('Energy-slice mean position')
grid on

figure(3)
set(gca,'FontSize',16)
plot(gs,s_mean(2,:)*1e3,'-r');hold on
plot(gs,s_mean(4,:)*1e3,'-b');hold off
xlabel('Delta (%)'); ylabel('XP,ZP (mrad)');
title('Energy-slice mean angle')
grid on

figure(4)
set(gca,'FontSize',16)
plot(s_mean(1,:)*1e3,s_mean(2,:)*1e3,'-r');hold on
plot(s_mean(3,:)*1e3,s_mean(4,:)*1e3,'-b');hold off
xlabel('X,Z (mm)'); ylabel('XP,ZP (mrad)');
title('Energy-slice mean centroide')
grid on



return