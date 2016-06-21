function plot_optic(n_period)
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot twiss parameter
global LATTICE DYNAMIC
%lattice_split(0.005)
%
if nargin==0 ; n_period=1;end
% 
twiss0=DYNAMIC.twiss; %first
twiss=cat(3,LATTICE.twiss);
betax=[twiss0(1,1) ; squeeze(twiss(1,1,:))];
betaz=[twiss0(3,3) ; squeeze(twiss(3,3,:))];
% 
disp0=DYNAMIC.disp; %first
disp=cat(2,LATTICE.disp);
dispx=[disp0(1) ; disp(1,:)'];
pos  =[0 ; cat(1,LATTICE.pos)] ;
pos_end=pos(length(pos));

% duplicate on super periode
betax_p=[];betaz_p=[];dispx_p=[];pos_p=[];
posn=[0:n_period]*pos_end;
for i=1:n_period
    betax_p=[betax_p ; betax];
    betaz_p=[betaz_p ; betaz];
    dispx_p=[dispx_p ; dispx];
    pos_p=[pos_p ; (pos+posn(i))];
end


% get lattice synopt
[synopt]=get_lattice;


figure(200)
set(gcf,'color','w')
set(gca,'FontSize',16)
plot(pos_p,betax_p,'-r','linewidth',2);hold on;
plot(pos_p,betaz_p,'-b','linewidth',2);
plot(pos_p,dispx_p*1000,'-g','linewidth',2);
%ylim([0 20])
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('Optical functions (m)')
legend('\beta_x','\beta_z','D_x *1000')
xlim([0 pos_p(length(pos_p))])
%xlim([0 0.7])
grid on




% figure(2)
% plot(sqrt(betaz_p.*betax_p))

% % save data in ascii format
% A=[ pos_p  betax_p  dispx_p betaz_p ];
% save optic.txt A -ASCII

