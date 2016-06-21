function plot_6D_tracking(phasespace,centre,sigma,emit,n_period,stat,kp)
% plot various data from 6D tracking
% kp : for few particles tracking 
global  LATTICE DYNAMIC

%
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
gam =(E+E0)/E0;
%
if nargin==4 ; n_period=1;stat='yes';kp=0; end
if nargin==5 ; stat='yes';kp=0; end
if nargin==6 ; kp=0; end
%
nelem=length(LATTICE);
if strcmp(stat,'yes')
    En    = cat(1,LATTICE.energy); 
    E     = [E ; En(:,1)]; gam=(E'+E0)/E0;
    
    pos  =cat(1,LATTICE.pos);
    pos  =[0 ; pos(1:nelem)];
    pos_end=pos(length(pos));
    pos_p=[];
    posn=[0:n_period]*pos_end;
    for i=1:n_period
        pos_p=[pos_p ; (pos+posn(i))];
    end
else
    pos_p=[1 : n_period];
end

% get lattice synopt
[synopt]=get_lattice;


figure(1)
set(gca,'fontsize',14)
plot(pos_p,centre(1,:),'-r');hold on
plot(pos_p,centre(3,:),'-b');
plot(pos_p,centre(5,:),'-k');
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('X, Y orbit (m)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('H plane','V plane','L plane')
grid on


figure(2)
set(gca,'fontsize',14)
plot(pos_p,sigma(1,:),'-r');hold on
plot(pos_p,sigma(3,:),'-b');
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('X, Y rms (m)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('H plane','V plane')
grid on


figure(3)
set(gca,'fontsize',14)
plot(pos_p,gam.*emit(1,:),'-r');hold on;
plot(pos_p,gam.*emit(2,:),'-b');
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('Normalised Emittances rms (mm.mrad)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('H plane','V plane')
%ylim([4 11]*1e-6)
grid on 


figure(4)
set(gca,'fontsize',14)
plot(pos_p,gam.*emit(3,:),'-k'); hold on
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('Normalised Emittance rms (m)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('L plane')
grid on

figure(5)
set(gca,'fontsize',14)
plot(pos_p,sigma(5,:),'-k'); hold on
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('Length rms (m)')
xlim([pos_p(1) pos_p(length(pos_p))])
grid on

% figure(51)
% set(gca,'fontsize',14)
% plot(pos_p,sigma(5,:)/3e8*1e15,'-k'); hold on
% if strcmp(stat,'yes')
%    yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
% end
% hold off;
% xlabel('S (m)');ylabel('Length rms (fs)')
% xlim([pos_p(1) pos_p(length(pos_p))])
% grid on

figure(6)
set(gca,'fontsize',14)
plot(pos_p,sigma(6,:),'-k'); hold on
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('de/e')
xlim([pos_p(1) pos_p(length(pos_p))])
grid on


figure(7)
set(gca,'fontsize',14)
plot(phasespace(5,:)*1e3,phasespace(6,:), '.b'); 
if kp>0;hold on;plot(phasespace(5,kp)*1e3,phasespace(6,kp), '-or');hold off;end
xlabel('s (mm)');ylabel('de/e')
grid on

figure(8)
set(gca,'fontsize',14)
plot(phasespace(3,:)*1e3,phasespace(4,:)*1e3, '.b'); 
if kp>0;hold on;plot(phasespace(1,kp)*1e3,phasespace(2,kp)*1e3, '-or');hold off;end
xlabel('x (mm)');ylabel('xp (mrad)')
grid on
