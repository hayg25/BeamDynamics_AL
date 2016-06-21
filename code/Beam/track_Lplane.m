function track_Lplane
% track Long plane in 6D and 2D to compar
% No wakes
global  DYNAMIC


np=7;
dx=0; % initial x ,z for tune measure 
de=-0.02; % de/e scan
nt=150;

disp= DYNAMIC.disp;
period =DYNAMIC.period;

sde=de/np; 
dd=(0:sde:de)';
np=size(dd);np=np(1);
particles=zeros(6,np);
particles(1,:)=disp(1)*dd + dx;
particles(3,:)=disp(3)*dd + dx;
particles(6,:)=dd;
%particles0=particles;


% track lattice
X=zeros(nt,np);
Y=zeros(nt,np);
for k=1:nt
    for j=1:period
        [particles] = track_particles(particles);
    end
    X(k,:)=particles(5,:);
    Y(k,:)=particles(6,:);
end


% get r56 & r566
p = polyfit(dd',X(1,:),4);
ddf=(de:0.001:0);
fit= p(5) + p(4)*ddf + p(3)*ddf.^2;
mcf=['fit : r56=' num2str(p(4)) '    ' ' r566=' num2str(p(3))];

figure(1)
plot(dd',X(1,:),'-b');hold on
plot(ddf,fit,'--r');hold off
xlabel('de/e'),ylabel('ds (m)')
legend('track',mcf)
grid on


figure(2)
set(gca,'Fontsize',14)
plot(X(:,:)*1e3,Y(:,:)*1e2,'-b');  
ylabel('dE/E (%)');xlabel('S (mm)')
grid on


return
% one turn track (2D)
X0=zeros(nt,np);
Y0=zeros(nt,np);
E =DYNAMIC.energy;
RF=DYNAMIC.RF; 
r56=-0.22;
r566=-5.35;
for k=1:nt
    [particles0]=RF_pass(particles0,E,RF(1),RF(2),RF(3));
    particles0(5,:)=particles0(5,:)+r56*particles0(6,:);
    particles0(5,:)=particles0(5,:)+r566*particles0(6,:).*particles0(6,:);
    X0(k,:)=particles0(5,:);
    Y0(k,:)=particles0(6,:);
end


figure(1)
plot(X(:,:),Y(:,:));hold on
plot(X0(:,:),Y0(:,:));hold off
grid on


return




