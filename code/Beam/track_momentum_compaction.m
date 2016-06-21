function track_momentum_compaction
% track one turn and get momentum compaction
% No wakes
global DYNAMIC
rep ='/home/loulergue/work/matlab/code/beta_structure/';
%input_file ='LUNEX5/APS-SC-V1/LH-CP2.str';
%input_file ='LUNEX5/APS-SC-V1/LH-CP2-chic1.str';
%input_file ='LUNEX5/APS-SC-V1/Linac1.str';
input_file ='chicane/dogleg-0.1-v2.str';
input_file ='chicane/arc-v2.str';
input_file ='chicane/dogleg-v51-SX.str';
lattice_beta2code(rep,input_file)



%lattice_split(1,'QP')


np=101;
dx=0;    % initial x ,z for tune measure 
de=0.03; % de/e scan

disp= DYNAMIC.disp;
period =DYNAMIC.period;

sde=de/np*2; 
dd=(-de:sde:de)';
np=size(dd);np=np(1);
particles=zeros(6,np);
particles(1,:)=disp(1)*dd + dx;
particles(3,:)=disp(3)*dd + dx;
particles(6,:)=dd;


% track one turn lattice
X=zeros(1,np);
Y=zeros(1,np);
% track from 1 to nelem
for j=1:period
    [particles] = track_particles(particles);
end
X(1,:)=particles(5,:);
Y(1,:)=particles(6,:);


% get r56 & r566
p  = polyfit(Y(1,:),X(1,:),5);
ddf=(-de:0.001:de);
%  second order
fit1= p(6) + p(5)*ddf + p(4)*ddf.^2;
mcf1=['fit : r56=' num2str(p(5)) '    ' ' r566=' num2str(p(4))];
%  third order
fit2= p(6) + p(5)*ddf + p(4)*ddf.^2 + p(3)*ddf.^3;
mcf2=['fit : r56=' num2str(p(5)) '    ' ' r566=' num2str(p(4)) ...
     '    ' ' r5666=' num2str(p(3))];
%  fourth order
fit3= p(6) + p(5)*ddf + p(4)*ddf.^2 + p(3)*ddf.^3 + p(2)*ddf.^4;
mcf3=['fit : r56=' num2str(p(5)) '    ' ' r566=' num2str(p(4)) ...
     '    ' ' r5666=' num2str(p(3)),'    ' ' r56666=' num2str(p(2)) ];

figure(1)
plot(Y(1,:),X(1,:),'-b');hold on
plot(ddf,fit1,'--r');
plot(ddf,fit2,'--m');
plot(ddf,fit3,'--g');
hold off
xlabel('de/e'),ylabel('ds (m)')
legend('track',mcf1,mcf2,mcf3)
grid on

% 
% figure(2)
% plot(X(1,:),Y(1,:),'-b');hold on
% plot(fit1,ddf,'--r');
% plot(fit2,ddf,'--m');
% plot(fit3,ddf,'--g');
% hold off
% ylabel('de/e'),xlabel('ds (m)')
% legend('track',mcf1,mcf2,mcf3)
% grid on

return




