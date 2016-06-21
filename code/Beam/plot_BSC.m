function plot_BSC
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot env
% with geometric epx epsz and de/e
% plot ellips in pipe
global LATTICE DYNAMIC

%
lattice_split(5)
% 
% Beam size
epsx=5e-8*1;
epsz=5e-8*1;
d=3e-3*1.;
nrms=4;
% Full pipe with in m
dxpipe=43*1e-3;
dzpipe=28*1e-3;

dxpipe=40*1e-3;
dzpipe=28*1e-3;


epipe=1e-3;
rr=30*1e-3; % graph lim
% Quad sext bore diameter
qd=40*1e-3;
sd=40*1e-3;

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

% get lattice synopt
[synopt]=get_lattice;


figure(1)
plot(pos,nrms*envx*1e3,'-r');hold on;
ylim([0 20]);
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
plot(pos,nrms*envz*1e3,'-b');hold off;
xlabel('S (m)');ylabel('rms Envelop (mm)')
legend('envx','envz')
xlim([0 pos(length(pos))])
grid on

% Pipe
phi=(0:pi/100 :2*pi);
% Pipe inner diameter
xpipe=dxpipe*cos(phi)/2;
zpipe=dzpipe*sin(phi)/2;
xpipe1=(dxpipe+epipe)*cos(phi)/2;
zpipe1=(dzpipe+epipe)*sin(phi)/2;
% Get max and plot ellips
rr=30*1e-3;
xmax=max(envx);xx=xmax*cos(phi);
zmax=max(envz);zz=zmax*sin(phi);

% quad
phi=[1 3 5 7]/4*pi;
xquad=qd*cos(phi)/2;
zquad=qd*sin(phi)/2;

% sext
phi=[1 3 5 7 9 11]/6*pi;
xsext=sd*cos(phi)/2;
zsext=sd*sin(phi)/2;


figure(2)
plot(nrms*xx*1e3,nrms*zz*1e3,'-b');hold on
plot(xquad*1e3,zquad*1e3,'or')
plot(xsext*1e3,zsext*1e3,'sg')
plot(xpipe*1e3,zpipe*1e3,'-k');
plot(xpipe1*1e3,zpipe1*1e3,'-k');hold off
set(gca,'FontSize',16)
xlabel('X (mm)')
ylabel('Z( mm)')
legend('Max beam','Min Quad poles','Min Sext poles','Pipe')
xlim([-rr rr]*1e3);
ylim([-rr rr]*1e3);
grid on




