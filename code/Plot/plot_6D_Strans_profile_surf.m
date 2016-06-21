function plot_6D_Strans_profile_surf(phasespace,qm,Ef,nbin)
% Plot trans phase space with image

nsig=4;
ncolor=128;
scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/2.5 scrsz(4)/1.5]);



figure(500)
% S-X plane
% Mesh over S
phi1=phasespace(5,:);
phimax=nsig*std(phi1);
step=(2*phimax)/nbin;
grille1=-phimax:step:phimax+mean(phi1);
% Mesh over X
phi2=phasespace(1,:);
phimax=nsig*std(phi2);
step=(2*phimax)/nbin;
grille2=-phimax:step:phimax+mean(phi2);
% imported from the net
[CX] = hist2(phi1,phi2,grille1,grille2);
ng=length(grille2);CX(1,:)=0;CX(ng,:)=0;CX(:,1)=0;CX(:,ng)=0;
b=2;h=ones(b)/b^2;
CX=filter2(h,CX);
mm=floor(max(max(CX))); % to fit color map
CX=CX*ncolor/mm;
CmapX=jet(ncolor);
%C1(1,:)=0;  % force background to black
CmapX(1,:)=1;  % force background to white
subplot(2,1,1)
set(gca,'FontSize',16)
image(grille1*1e3,grille2*1e3,CX)
colormap(CmapX)
set(gca,'YDir','normal')
xlabel('S (mm)');ylabel('X (mm)'); grid on;
grid on ;

% S-Z plane
% Mesh over Z
% Mesh over ZP
phi4=phasespace(3,:);
phimax=nsig*std(phi4);
step=(2*phimax)/nbin;
grille4=-phimax:step:phimax+mean(phi4);
% imported from the net
[CZ] = hist2(phi1,phi4,grille1,grille4);
ng=length(grille1);CZ(1,:)=0;CZ(ng,:)=0;CZ(:,1)=0;CZ(:,ng)=0;
b=2;h=ones(b)/b^2;
CZ=filter2(h,CZ);
mm=floor(max(max(CZ))); % to fit color map
CZ=CZ*ncolor/mm;
CmapZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapZ(1,:)=1;  % force background to white
subplot(2,1,2)
set(gca,'FontSize',16)
image(grille1*1e3,grille4*1e3,CZ)
colormap(CmapZ)
set(gca,'YDir','normal')
xlabel('S (mm)');ylabel('Z (mm)'); grid on;
grid on

set(0,'DefaultFigurePosition','remove');

% Scatter color energy
color=phasespace(6,:);
figure(700)
subplot(2,1,1)
 scatter(phasespace(5,:)*1e3,phasespace(1,:)*1e3,20,color,'.')
  xlabel('S (mm)');ylabel('X (mm)');
  grid on;
  set(gca,'FontSize',16)
  xlim([-0.05 0.05]);ylim([-1 1])
subplot(2,1,2)
 scatter(phasespace(5,:)*1e3,phasespace(3,:)*1e3,20,color,'.')
 xlabel('S (mm)'); ylabel('Z (mm)');
 grid on ;
 xlim([-0.05 0.05]);ylim([-1. 1.])
 set(gca,'FontSize',16)
 

