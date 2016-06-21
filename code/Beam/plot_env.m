function plot_env(epsx,epsz,d,n_period)
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot env
% with geometric epx epsz and de/e
global LATTICE DYNAMIC
%
if nargin==3 ; n_period=1;end
%
%lattice_split(5)
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
ss=cat(1,LATTICE.length);
%
envx=sqrt(epsx*betax + d^2*dispx.^2);
envz=sqrt(epsz*betaz);


% duplicate on super periode
envx_p=[];envz_p=[];pos_p=[];
posn=[0:n_period]*pos_end;
for i=1:n_period
    envx_p=[envx_p ; envx];
    envz_p=[envz_p ; envz];
    pos_p=[pos_p ; (pos+posn(i))];
end

% get lattice synopt
[synopt]=get_lattice;

figure(201)
set(gcf,'color','w')
set(gca,'FontSize',16)
plot(pos_p,envx_p*1e3,'-r','linewidth',2);hold on;
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k','linewidth',2);
plot(pos_p,envz_p*1e3,'-b','linewidth',2);hold off;
xlabel('S (m)');ylabel('rms Envelop (mm)')
legend('envx','envz')
xlim([0 pos_p(length(pos_p))])
%ylim([0 5])
grid on

% % save data in ascii format
% A=[ envx_p  envz_p  ];
% save env_inj.txt A -ASCII

% phi=(0:pi/100 :2*pi);
% nrms=4;
% % Pipe inner diameter
% dxpipe=45*1e-3;
% dzpipe=35*1e-3;
% xpipe=dxpipe*cos(phi)/2;
% zpipe=dzpipe*sin(phi)/2;
% % Get max and plot ellips
% rr=30*1e-3;
% xmax=max(envx_p);xx=xmax*cos(phi);
% zmax=max(envz_p);zz=zmax*sin(phi);
% 
% figure(2)
% plot(xpipe*1e3,zpipe*1e3,'-k');hold on
% plot(nrms*xx*1e3,nrms*zz*1e3,'-b')
% hold off
% xlim([-rr rr]*1e3);
% ylim([-rr rr]*1e3);
% grid on
% 
% 
% 
% 
% % Mean size
% if n_period==1
%    sum(envx(2:length(envx)).*ss)/sum(ss);
%    sum(envz(2:length(envx)).*ss)/sum(ss);
% end
% 
% 
