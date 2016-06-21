function plot_6D_long_profile_surfE(phasespace,qm,Ef,nbin)
% Plot long profile in MeV from LWFA
nsig=3;
%
% phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
% phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,~, s_rms, s_emit,cur]=bunch_statistics_slice(phasespace,qm,nbin,nsig);
gam=Ef/0.511;
emitxs =s_emit(1,:);
emitzs =s_emit(2,:);
des    =s_rms(6,:);
Bs= cur./emitxs./emitzs./des/gam/gam;


% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,Bs);Bs=smooth;

% plot
limx=[gs(1) gs(nbin)]*1e6;

nbin=floor(length(gs)/2);
% Mesh over length
phi5=phasespace(5,:);
phimax=nsig*std(phi5);
step=(2*phimax)/nbin;
grille5=-phimax:step:phimax;
% Mesh over E
phi6=phasespace(6,:);
phimax=nsig*std(phi6);
step=(2*phimax)/nbin;
grille6=-phimax:step:phimax;
% imported from the net
[C] = hist2(phi5,phi6,grille5,grille6);
b=2;h=ones(b)/b^2;
C=filter2(h,C);
mm=floor(max(max(C))); % to fit color map
C1=colormap(jet(mm));
%C1(1,:)=0;  % force background to black
C1(1,:)=1;  % force background to white

scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.]);


figure(100)
subplot(2,1,1)
set(gca,'FontSize',14)
image(grille5*1e6,(grille6*Ef+Ef),C)
colormap(C1)
set(gca,'YDir','normal')
xlabel('S (µm)');ylabel('E (MeV)'); grid on;
xlim(limx);%ylim([-6 6])
grid on ;

subplot(2,1,2)
set(gca,'FontSize',14)
plot(gs*1e6 ,cur,'-b')
xlabel('S (µm) ');ylabel('Peak current (A)');
xlim(limx);
grid on

set(0,'DefaultFigurePosition','remove');

