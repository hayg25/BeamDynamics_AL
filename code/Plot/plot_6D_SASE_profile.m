function plot_6D_SASE_profile(phasespace,qm,Ef,lambda,ond,nbin)
% Plot long profile

%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,s_mean s_rms s_emit,cur,s_twiss]=bunch_statistics_slice(phasespace,qm,nbin);
gam=Ef/0.511;
emitxs =s_emit(1,:);
emitzs =s_emit(2,:);
des    =s_rms(6,:);

% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;


% plot
limx=[gs(1) gs(nbin)]*1e3;
%limx=[gs(1) gs(length(gs))]*1e3;
limx=[-15e-6 15e-6]*1e3;
%
[ Lsat, Lsat1d, Psat,Psat1d,Lg,Lg1d ] = get_Lsat_FEL(lambda,ond,emitxs,des,cur,3,Ef);
fprintf('\n')
fprintf('From Ming-Xie FEL at %5.2d m with periode %5.2d m \n',lambda,ond)
fprintf('   FEL Lsat1d = %5.2d m  Psat1d = %5.2d W  \n',min(Lsat1d),max(Psat1d))
fprintf('   FEL Lsat   = %5.2d m  Psat   = %5.2d W  \n',min(Lsat),  max(Psat))


figure(300)
set(gca,'FontSize',14)
plot(gs*1e3 ,Lg,'-b'); hold on
plot(gs*1e3 ,Lg1d,'--b'); hold off
xlabel('S (mm) ');ylabel('FEL Lgain slice (m) ');
grid on
xlim(limx);
ylim([0 0.5])

figure(301)
set(gca,'FontSize',14)
plot(gs*1e3 ,Lsat,'-b'); hold on
plot(gs*1e3 ,Lsat1d,'--b'); hold off
xlabel('S (mm) ');ylabel('FEL Lsat slice (m) ');
grid on
xlim(limx);
ylim([0 10])

figure(302)
set(gca,'FontSize',14)
plot(gs*1e3 ,Psat*1e-6,'-b'); hold on
plot(gs*1e3 ,Psat1d*1e-6,'--b'); hold off
xlabel('S (mm) ');ylabel('FEL Psat slice (MW) ');
grid on
xlim(limx);

return
% scatter
color=phasespace(6,:)*100;
figure(400)
scatter3(phasespace(5,:)*1e6,phasespace(1,:)*1e6,phasespace(3,:)*1e6,10,color,'.')
xlabel('S (µm)');ylabel('X (µm)');zlabel('X (µm)');
colorbar
set(gca,'FontSize',14)
%xlim([-5 5])

% color=phasespace(6,:)*100;
% figure(500)
% scatter3(phasespace(5,:)*1e6,phasespace(1,:)*1e6,phasespace(2,:)*1e6,10,color,'.')
% xlabel('S (µm)');ylabel('X (µm)');zlabel('XpP (µm)');
% colorbar
% set(gca,'FontSize',14)
