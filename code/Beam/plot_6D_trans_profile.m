function plot_6D_trans_profile(phasespace)
% Plot long profile


scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.5]);

figure(500)
subplot(1,2,1)
set(gca,'FontSize',16)
plot(phasespace(1,:)*1e3,phasespace(2,:)*1e3, '.b','Markersize',0.05); 
xlabel('X (mm)');ylabel('XP (mrad)'); grid on;
grid on ;
subplot(1,2,2)
set(gca,'FontSize',16)
plot(phasespace(3,:)*1e3,phasespace(4,:)*1e3, '.b','Markersize',0.05); 
xlabel('X (mm)');ylabel('XP (mrad)'); grid on;
grid on ;

set(0,'DefaultFigurePosition','remove');

figure(600)
set(gca,'fontsize',16)
plot(phasespace(1,:)*1e3,phasespace(3,:)*1e3, '.b','Markersize',0.05); 
xlabel('X (mm)');ylabel('Z (mm)'); grid on;
grid on
