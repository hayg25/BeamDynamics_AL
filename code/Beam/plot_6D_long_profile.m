function plot_6D_long_profile(phasespace,qm,Ef,nbin)
% Plot long profile

gam=Ef/0.511;
Nsigma = 4;
grid_points = nbin;
%
% phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
% phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
% sur slices
% get ps data
s_rms = std(phasespace(5,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms,Nsigma*s_rms,grid_points)';
% binning for the slice parameters
[A,bin] = histc(phasespace(5,:),grille);

ws=[] ;emitxs=[];emitzs=[];des=[];
for i=1:grid_points
    num_par = length(find(bin==i));
    if(num_par >= 5)
        slicephase = phasespace(:,find(bin==i));
        %[x,b_mean,b_rms,b_emit,b_twiss,weight] = beam_statistics(slicephase);
        [b_mean b_rms b_emit]=bunch_statistics(slicephase,0);
        emitxs =[emitxs  b_emit(1)];
        emitzs =[emitzs  b_emit(2)];
        des    =[des     b_rms(6)];
        ws     =[ws      num_par];
    else
        ws     =[ws      0];
        emitxs =[emitxs  0];
        emitzs =[emitzs  0];
        des    =[des     0];
    end
end
cur=(ws/(2*Nsigma*s_rms)*grid_points*3e08)*qm;
gs=2*Nsigma*s_rms*( (1:grid_points)-grid_points/2 )/grid_points;
Bs= cur./emitxs./emitzs./des/gam/gam;

% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,Bs);Bs=smooth;

% plot
limx=[gs(1) gs(grid_points)]*1e3*1 ;
%limx=[gs(1) gs(length(gs))]*1e3;

figure(100)
subplot(2,2,1)
set(gca,'FontSize',14)
plot(phasespace(5,:)*1e3,phasespace(6,:)*1e2,'.b');
xlabel('S (mm)');ylabel('de/e (%)'); grid on;
%ylim([-0.5 0.5]);
xlim(limx);
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
plot(gs*1e3 ,gam*emitxs*1e6,'-b'); hold on ;plot(gs*1e3 ,gam*emitzs*1e6,'-r'); hold off
xlabel('S (mm) ');ylabel('emit rms slice (mm.mrad)');
legend('X','Z')
xlim(limx);
grid on;

return

figure(200)
set(gca,'FontSize',14)
plot(gs*1e3 ,Bs/100,'-b')
xlabel('S (mm) ');ylabel('Brightness slice (A/mm^2/mrad^2/%) ');
grid on
xlim(limx);

%
[ Lsat, Lsat1d ] = get_Lsat_FEL( 20e-9,15e-3,emitxs,des,cur,7,Ef);
figure(300)
set(gca,'FontSize',14)
plot(gs*1e3 ,Lsat,'-b'); hold on
plot(gs*1e3 ,Lsat1d,'--b'); hold off
xlabel('S (mm) ');ylabel('FEL Lsat slice (m) ');
grid on
xlim(limx);
%ylim([0 50])




