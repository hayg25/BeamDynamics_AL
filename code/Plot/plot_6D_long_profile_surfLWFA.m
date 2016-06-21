function plot_6D_long_profile_surfLWFA(phasespace,qm,Ef,nbin)
% Plot profile in LWFA fashion : Divergence vs Energy
nsige=4;
nsigd=6;
%
[gs,~, ~, ~,cur]=bunch_statistics_slice(phasespace,qm,nbin,nsige,6);

% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;

% plot
limx=[gs(1) gs(nbin)]*Ef+Ef;

nbin=floor(length(gs)/2);
% Mesh over divergence
phi5=phasespace(2,:);
phimax=nsigd*std(phi5);
step=(2*phimax)/nbin;
grille5=-phimax:step:phimax;
% Mesh over E
phi6=phasespace(6,:);
phimax=nsige*std(phi6);
step=(2*phimax)/nbin;
grille6=-phimax:step:phimax;
% imported from the net
[C] = hist2(phi6,phi5,grille6,grille5);
b=2;h=ones(b)/b^2;
C=filter2(h,C);
mm=floor(max(max(C))); % to fit color map
C1=colormap(jet(mm));
C1(1,:)=1;  % force background to white

scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.]);

figure(100)

subplot(2,1,1)
set(gca,'FontSize',14)
image((grille6*Ef+Ef),(grille5*1e3),C)
colormap(C1)
set(gca,'YDir','normal')
xlabel('E (MeV)');ylabel('Xp (mrad)'); grid on;
xlim(limx);%ylim([-6 6])
grid on ;

subplot(2,1,2)
set(gca,'FontSize',14)
plot((gs*Ef+Ef), cur,'-b')
set(gca,'yticklabel','')
xlabel('E (MeV)');ylabel('u. a.');
xlim(limx);
grid on

set(0,'DefaultFigurePosition','remove');



