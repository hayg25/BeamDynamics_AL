function plot_6D_tracking_min_pub(phasespace,centre,sigma,emit,n_period,stat,kp)
% plot various data from 6D tracking
% kp : for few particles tracking 
global  LATTICE DYNAMIC

%
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
gamm =(E+E0)/E0;
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
subplot('Position',[0.07 0.18 0.9 0.75])
set(gca,'fontsize',16)
set(gcf,'color','w')
plot(pos_p,sigma(1,:)*1e3,'-r','linewidth',2);hold on
plot(pos_p,sigma(3,:)*1e3,'-b','linewidth',2);
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)')
ylabel('rms envelop (mm)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('Horizontal plane','Vertical plane')
box off
% text(0.15,0.75,'a1)','fontsize',22) 
% text(3,0.75,'Strong focusing case','fontsize',22) 
% text(0.05,-0.15,'Quad','fontsize',22) 
% text(1.15,-0.15,'Chicane','fontsize',22) 
% text(5.5,-0.15,'Undulator','fontsize',22) 

% text(0.15,0.75,'b1)','fontsize',22) 
% text(3.5,0.75,'Chromatic matching case','fontsize',22) 
% text(0.05,-0.15,'Quad','fontsize',22) 
% text(1.15,-0.15,'Chicane','fontsize',22) 
% text(3.5,-0.15,'Quad','fontsize',22) 
% text(7,-0.15,'Undulator','fontsize',22) 
grid on



figure(300)
set(gca,'fontsize',16)
set(gcf,'color','w')
plot(pos_p,emit(1,:)*1e6*gamm,'-r','linewidth',2);hold on
plot(pos_p,emit(2,:)*1e6*gamm,'-b','linewidth',2)
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)')
ylabel('rms Norm. Emit.  (\pi mm.mrad)')
xlim([pos_p(1) pos_p(length(pos_p))])
legend('Horizontal plane','Vertical plane')
box off
grid on

% figure(400)
% set(gca,'fontsize',16)
% plot(pos_p,sigma(5,:)*1e6,'-r','linewidth',2);hold on
% if strcmp(stat,'yes')
%    yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
% end
% hold off;
% xlabel('S (m)')
% ylabel('rms length  (µm)')
% xlim([pos_p(1) 2.7])
% legend('Without emittance','With emittance')
% box off
% grid on


% % Scatter color energy
% color=phasespace(6,:);
% figure(600)
%   scatter(phasespace(5,:)*1e6,phasespace(6,:)*1e2,20,color,'.')
%   xlabel('Z (\mum)');ylabel('dE/E (%)');
%   grid on;
%   set(gca,'FontSize',18)
%   xlim([-20 20]);ylim([-4 4]) 
  

return
% Scatter color energy
color=phasespace(6,:);
figure(700)
subplot(1,2,1)
 scatter(phasespace(1,:)*1e3,phasespace(2,:)*1e3,20,color,'.')
  xlabel('x (mm)');ylabel('xp (mrad)');
  grid on;
  set(gca,'FontSize',18)
  xlim([-2 2]);ylim([-0.3 0.3])
  text(-3.5,0.25,'b2)','fontsize',22) 
  text(0.5,0.25,'Horizontal','fontsize',22)
subplot(1,2,2)
 scatter(phasespace(3,:)*1e3,phasespace(4,:)*1e3,20,color,'.')
 xlabel('y (mm)'); ylabel('yp (mrad)');
 grid on ;
 xlim([-0.5 0.5]);ylim([-0.2 0.2])
 text(0.15,0.16,'Vertical','fontsize',22) 
 set(gca,'FontSize',18)


