function plot_bunch
% test bunch
% plot twiss parameter
%
np  =10000;
E   =100;
long=[0.001 0.001];
eps =[1 1]*1e-6;
twiss=[1 0. 1 0];
disp =[0 ; 0 ; 0 ; 0];
%
[phasespace]=bunch_generation(twiss,disp,eps,long,E,np);


figure(1)
subplot(3,1,1)
plot(phasespace(1,:)*1e3,phasespace(2,:)*1e3, '.k')
xlabel('x (mm)');ylabel('xp (mrad)')
grid on

subplot(3,1,2)
plot(phasespace(2,:)*1e3,phasespace(4,:)*1e3, '.k')
xlabel('y (mm)');ylabel('yp (mrad)')
grid on

subplot(3,1,3)
plot(phasespace(5,:)*1e3,phasespace(6,:), '.k')
xlabel('s (mm)');ylabel('de/e')
grid on


return