function plot_6D_long_profile_surf(phasespace,qm,Ef,nbin)
% Plot long profile

%
% phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
% phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,s_mean s_rms s_emit,cur]=bunch_statistics_slice(phasespace,qm,nbin);
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


% figure(101)
% set(gca,'FontSize',14)
% image(grille5*1e3,(1+grille6)*Ef,C)
% colormap(C1)
% set(gca,'YDir','normal')
% xlabel('S (mm)');ylabel('E (MeV)'); grid on;
% xlim(limx);
% grid on ;

figure(100)
subplot(2,2,1)
set(gca,'FontSize',14)
image(grille5*1e3,grille6*100,C)
colormap(C1)
set(gca,'YDir','normal')
xlabel('S (mm)');ylabel('de/e (%)'); grid on;
xlim(limx);%ylim([-6 6])
grid on ;
subplot(2,2,2)
set(gca,'FontSize',14)
plot(gs*1e3 ,cur,'-b')
xlabel('S (mm) ');ylabel('Peak current (A)');
xlim(limx);
grid on
subplot(2,2,3)
set(gca,'FontSize',14)
plot(gs*1e3 , des*1e2)
xlabel('S (mm) ');ylabel('de/e rms slice (%)');
xlim(limx);
grid on
subplot(2,2,4)
set(gca,'FontSize',14)
plot(gs*1e3 ,gam*emitxs*1e6,'-r'); hold on ;plot(gs*1e3 ,gam*emitzs*1e6,'-b'); hold off
xlabel('S (mm) ');ylabel('emit rms slice (mm.mrad)');
legend('X','Z')
xlim(limx);
grid on;

set(0,'DefaultFigurePosition','remove');

figure(200)
surf(C)

return
figure(101)
subplot(1,2,1)
set(gca,'FontSize',14)
image(grille5*1e3,grille6*100,C)
colormap(C1)
set(gca,'YDir','normal')
xlabel('S (mm)');ylabel('de/e (%)'); grid on;
xlim([-0.04 0.04]);ylim([-6 6])
subplot(1,2,2)
 color=phasespace(6,:);
 scatter(phasespace(1,:)*1e3,phasespace(2,:)*1e3,20,color,'.')
  xlabel('X (mm)');ylabel('XP (mrad)');
  grid on;
  set(gca,'FontSize',14)
  xlim([-1 1]);ylim([-0.5 0.5])
grid on ;

%save S2I_SM_CSR_0.1µm.mat gs des emitxs

return

figure(300)
subplot(3,1,1)
set(gca,'FontSize',14)
plot(gs*1e3 ,cur,'-b')
xlabel('S (mm) ');ylabel('Peak current (A)');
xlim(limx);
grid on
subplot(3,1,2)
set(gca,'FontSize',14)
plot(gs*1e3,s_twiss(1,:),'-r');hold on
plot(gs*1e3,s_twiss(3,:),'-b');hold off
xlabel('S (mm) ');ylabel('Beta');
legend('X','Z')
xlim(limx);
grid on
subplot(3,1,3)
set(gca,'FontSize',14)
plot(gs*1e3,s_twiss(2,:),'-r');hold on
plot(gs*1e3,s_twiss(4,:),'-b');hold off
xlabel('S (mm) ');ylabel('Alpha');
legend('X','Z')
xlim(limx);
grid on;

return

% figure(200)
% set(gca,'FontSize',14)
% plot(gs*1e3 ,Bs/100,'-b')
% xlabel('S (mm) ');ylabel('Brightness slice (A/mm^2/mrad^2/%) ');
% grid on
% xlim(limx);



% scatter
color=phasespace(6,:)*100;
figure(400)
scatter3(phasespace(5,:)*1e6,phasespace(1,:)*1e6,phasespace(3,:)*1e6,10,color,'.')
xlabel('S (µm)');ylabel('X (µm)');zlabel('X (µm)');
colorbar
set(gca,'FontSize',14)
%xlim([-5 5])
