function plot_6D_long_profile_surf_proj_astra(phasespace,qm,Ef,nbin)
% Plot long profile + slice data
% + projected slice centroid

load astra_long_SC_32bin_smooth1 gs cur des emitxs emitzs
gsa=gs+1.5e-7;cura=cur;desa=des;emitxsa=emitxs;emitzsa=emitzs;
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cura);cura=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,desa);desa=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxsa);emitxsa=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzsa);emitzsa=smooth;


[gs,s_mean s_rms s_emit,cur]=bunch_statistics_slice(phasespace,qm,nbin);
gam=Ef/0.511;
emitxs =s_emit(1,:);
emitzs =s_emit(2,:);
des    =s_rms(6,:);
%
xs     =s_mean(1,:);
xps    =s_mean(2,:);
zs     =s_mean(3,:);
zps    =s_mean(4,:);

% % Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,xs);xs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,xps);xps=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,zs);zs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,zps);zps=smooth;

% plot
limx=[gs(1) gs(nbin)]*1e3;
%limx=[-15e-6 15e-6]*1e3;
%limx=[gs(1) gs(length(gs))]*1e3;

nsig=4;nbin=floor(length(gs)/2);
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
[C,g5,g6] = hist2(phi5,phi6,grille5,grille6);
b=2;h=ones(b)/b^2;
C=filter2(h,C);
mm=floor(max(max(C))); % to fit color map
C1=colormap(jet(mm));
%C1(1,:)=0;  % force background to black
C1(1,:)=1;  % force background to white

scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.]);
figure(100)
set(gcf,'color','w')
subplot(2,2,1)
set(gca,'FontSize',16)
image(grille5*1e3,grille6*100,C)
colormap(C1)
set(gca,'YDir','normal')
xlabel('S (mm)');ylabel('de/e (%)'); grid on;
xlim(limx);%ylim([-6 6])
grid on ;
subplot(2,2,2)
set(gca,'FontSize',16)
plot(gs*1e3 ,cur,'-b'); hold on
plot(gsa*1e3 ,cura,'-r'); hold off
xlabel('S (mm) ');ylabel('Peak current (A)');
xlim(limx);
grid on
subplot(2,2,3)
set(gca,'FontSize',16)
plot(gs*1e3, des*1e2,'-b'); hold on
plot(gsa*1e3 , desa*1e2,'-r'); hold off
xlabel('S (mm) ');ylabel('dE/e rms slice (%)');
xlim(limx);
grid on
subplot(2,2,4)
set(gca,'FontSize',16)
plot(gs*1e3 ,gam*emitxs*1e6,'-r'); hold on ;
plot(gs*1e3 ,gam*emitzs*1e6,'-b'); hold off;
xlabel('S (mm) ');ylabel('emit rms slice (mm.mrad)');
legend('X','Z')
xlim(limx);
grid on;

set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/4.]);
figure(101)
set(gcf,'color','w')
subplot(1,2,1)
set(gca,'FontSize',16)
plot(gs*1e3 ,xs*1e6,'-r'); hold on ;
plot(gs*1e3 ,zs*1e6,'-b'); hold off ;
xlabel('S (mm) ');ylabel('Proj slice position (µm)');
legend('X','Z')
xlim(limx);
ylim([-120 120])
grid on
subplot(1,2,2)
set(gca,'FontSize',16)
plot(gs*1e3 ,xps*1e6,'-r'); hold on ;
plot(gs*1e3 ,zps*1e6,'-b'); hold off ;
xlabel('S (mm) ');ylabel('Proj slice angle (µrad)');
legend('X','Z')
xlim(limx);
ylim([-10 10])
grid on;

set(0,'DefaultFigurePosition','remove');


