function plot_6D_tracking_min_env(phasespace,centre,sigma,emit,n_period,stat)
% plot various data from 6D tracking
% kp : for few particles tracking 
global  LATTICE DYNAMIC

%
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;

%
if nargin==4 ; n_period=1;stat='yes'; end
if nargin==5 ; stat='yes';kp=0; end
%
nelem=length(LATTICE);
if strcmp(stat,'yes')
    En    = cat(1,LATTICE.energy); 
    E     = [E ; En(:,1)];
    
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
set(gcf,'color','w')
set(gca,'fontsize',20)
plot(pos_p,sigma(1,:)*1e3,'-r','linewidth',2);hold on
plot(pos_p,sigma(3,:)*1e3,'-b','linewidth',2);
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
ylabel('X, Y rms (mm)')
xlabel('S (m)');
xlim([pos_p(1) pos_p(length(pos_p))])
hold off;
legend('H plane','V plane')
box off
grid on

figure(2)
set(gcf,'color','w')
set(gca,'fontsize',20)
plot(pos_p,sigma(5,:)*1e3,'-k','linewidth',2); hold on
if strcmp(stat,'yes')
   yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
end
hold off;
xlabel('S (m)');ylabel('rms length (mm)')
xlim([pos_p(1) pos_p(length(pos_p))])
%ylim([0 4])
box off
grid on
