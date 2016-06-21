function plot_6D_tracking_min(phasespace,centre,sigma,emit,n_period,stat,kp)
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

scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.]);
figure(200)
set(gcf,'color','w')
subplot('position',[.1 .64 .85 .25])
set(gca,'fontsize',16)
plot(pos_p,sigma(1,:)*1e3,'-r','linewidth',2);hold on
plot(pos_p,sigma(3,:)*1e3,'-b','linewidth',2);
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k','linewidth',1);
end
hold off;
ylabel('X, Y rms (mm)')
set(gca,'XTickLabel',[])
xlim([pos_p(1) pos_p(length(pos_p))])
legend('H plane','V plane')
box off
grid on

subplot('position',[.1 .37 .85 .25])
set(gca,'fontsize',16)
plot(pos_p,gam.*emit(1,:)*1e6,'-r','linewidth',2);hold on;
plot(pos_p,gam.*emit(2,:)*1e6,'-b','linewidth',2);
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k','linewidth',1);
end
hold off;
ylabel('Norm Emit rms (mm.mrad)')
set(gca,'XTickLabel',[])
xlim([pos_p(1) pos_p(length(pos_p))])
box off
grid on

subplot('position',[.1 .1 .85 .25])
set(gca,'fontsize',16)
plot(pos_p,sigma(5,:)*1e3,'-k','linewidth',2); hold on
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k','linewidth',1);
end
hold off;
xlabel('S (m)');ylabel('Length rms (mm)')
xlim([pos_p(1) pos_p(length(pos_p))])
box off
grid on
set(0,'DefaultFigurePosition','remove');
