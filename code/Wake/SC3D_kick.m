function [ phasespace ] = SC3D_kick(phasespace,q,E,E0,L)
%UNTITLED Compute 3D space charge kick
%   Phase-space
%   q total charge in Coulomb
%   E energyekinetic (MeV)
%   E0 rest mass     (MeV)
%   L integration path in m

%   Use fast poisson 3D solver based on FFT
%   ==> most CPU = interp3

global  DYNAMIC

%
nrms=6;
gam =(E+E0)/E0;
eps0=8.7535e-12;
qm=q/length(phasespace);

nbin3=[30 30 60]; % default
if isfield( DYNAMIC, 'nbin3'); nbin3= DYNAMIC.nbin3 ; end
nbinx=nbin3(1);nbinz=nbin3(2);nbins=nbin3(3);

wind3=10; % default
if isfield( DYNAMIC, 'wind3'); wind3= DYNAMIC.wind3 ; end

% Make the grid on bunch frame boosted in s direction
p=phasespace;p(5,:)=p(5,:)*gam;% boosted in s
xrms=std(p(1,:));xx=nrms*xrms;
zrms=std(p(3,:));zz=nrms*zrms;
srms=std(p(5,:));ss=nrms*srms;
hx=2*xx/nbinx;xedge=(-xx:hx:xx);
hz=2*zz/nbinz;zedge=(-zz:hz:zz);
hs=2*ss/nbins;sedge=(-ss:hs:ss);

% Do the 3D binning
X=[p(1,:)' p(3,:)' p(5,:)']; 
[count , ~, mid] = histcn(X,xedge,zedge,sedge);
x=[mid{1}];z=[mid{2}];s=[mid{3}];

% Smooth by FFT along s
cut=floor(nbins/2-wind3);
if cut < 1; cut=1;end;
cfft=fft(count,[],3);
cfft(:,:,(cut:nbins-cut))=0;
count=real(ifft(cfft,[],3));

% Enlarge count by zero at border 
% Convert to - (charge density) / eps0
f=zeros(nbinx+2,nbinz+2,nbins+2);
f(2:nbinx+1,2:nbinz+1,2:nbins+1)=-qm*count/hx/hz/hs/eps0;

% Get potential by poisson 3D solver 
% Cubic border set to 0 (coulb be improved) at 6 sigmas
u1=poisson3d(f,hx^2,hz^2,hs^2,0,0,0,0,0,0,2);

% Get E field by gradient solver
[Ex,Ez,Es]=gradient(u1,hx,hz,hs); % Ex & Ez reversed fom help!
% Ei size= nbinx nbinz nbins in Volt
% Ex,Ez scale 1/gam  Es as 1/gam2

% Interp3 Ei over phasespace 0 for out
[xi,zi,si]=meshgrid(x,z,s);
Exn=interp3(xi,zi,si,Ex,p(1,:),p(3,:),p(5,:),'linear',0);
Ezn=interp3(xi,zi,si,Ez,p(1,:),p(3,:),p(5,:),'linear',0);
Esn=interp3(xi,zi,si,Es,p(1,:),p(3,:),p(5,:),'linear',0);

% Apply to phasespace (scale as 1/gam3)
% Energy in MeV
dE =Esn*L*1e-6;
% Radial kick in radian + Lorentz E field transform 1/gam
dxp= Exn/gam/E/1e6*L;
dzp= Ezn/gam/E/1e6*L;
% 
 phasespace(2,:)=phasespace(2,:)+dxp;
 phasespace(4,:)=phasespace(4,:)+dzp;
 phasespace(6,:)=phasespace(6,:)+dE/E;

end

