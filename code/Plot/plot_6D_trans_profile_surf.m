function plot_6D_trans_profile_surf(phasespace,qm,Ef,nbin)
% Plot trans phase space with image

nsig=2;
ncolor=128;
scrsz = get(0,'ScreenSize');
set(0,'DefaultFigurePosition',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2.5]);



figure(500)
set(gcf,'color','w')
% X plane
% Mesh over X
phi1=phasespace(1,:);
phimax=nsig*std(phi1);
step=(2*phimax)/nbin;
grille1=(-phimax:step:phimax) + mean(phi1);
% Mesh over XP
phi2=phasespace(2,:);
phimax=nsig*std(phi2);
step=(2*phimax)/nbin;
grille2=(-phimax:step:phimax) + mean(phi2);
% imported from the net
[CX] = hist2(phi1,phi2,grille1,grille2);
ng=length(grille1);CX(1,:)=0;CX(ng+2,:)=0;CX(:,1)=0;CX(:,ng+2)=0;
b=2;h=ones(b)/b^2;
CX=filter2(h,CX);
mm=floor(max(max(CX))); % to fit color map
CX=CX*ncolor/mm;
CmapX=jet(ncolor);
%C1(1,:)=0;  % force background to black
CmapX(1,:)=1;  % force background to white

subplot(1,2,1)
set(gca,'FontSize',16)
image(grille1*1e3,grille2*1e3,CX)
colormap(CmapX)
set(gca,'YDir','normal')
xlabel('X (mm)');ylabel('XP (mrad)'); grid on;
grid on ;

% Z plane
% Mesh over Z
phi3=phasespace(3,:);
phimax=nsig*std(phi3);
step=(2*phimax)/nbin;
grille3=(-phimax:step:phimax) + mean(phi3);
% Mesh over ZP
phi4=phasespace(4,:);
phimax=nsig*std(phi4);
step=(2*phimax)/nbin;
grille4=(-phimax:step:phimax) + mean(phi4);
% imported from the net
[CZ] = hist2(phi3,phi4,grille3,grille4);
ng=length(grille3);CZ(1,:)=0;CZ(ng+2,:)=0;CZ(:,1)=0;CZ(:,ng+2)=0;
b=2;h=ones(b)/b^2;
CZ=filter2(h,CZ);
mm=floor(max(max(CZ))); % to fit color map
CZ=CZ*ncolor/mm;
CmapZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapZ(1,:)=1;  % force background to white
subplot(1,2,2)
set(gca,'FontSize',16)
image(grille3*1e3,grille4*1e3,CZ)
colormap(CmapZ)
set(gca,'YDir','normal')
xlabel('Z (mm)');ylabel('ZP (mrad)'); grid on;
grid on

set(0,'DefaultFigurePosition','remove');


figure(600)
set(gcf,'color','w')
set(gcf,'colormap',[])
% X Z plane
% Mesh over X
phi1=phasespace(1,:);
phimax1=nsig*std(phi1);
% Mesh over Z
phi3=phasespace(3,:);
phimax3=nsig*std(phi3);
% Square size
%phimax=max(phimax1,phimax3);
%phimax=0.0003;
step1=(2*phimax1)/nbin;
grille1=(-phimax1:step1:phimax1) + mean(phi1);
step3=(2*phimax3)/nbin;
grille3=(-phimax3:step3:phimax3) + mean(phi3);

% imported from the net
[CXZ] = hist2(phi1,phi3,grille1,grille3);
ng=length(grille1);CXZ(1,:)=0;CXZ(ng+2,:)=0;CXZ(:,1)=0;CXZ(:,ng+2)=0;
b=2;h=ones(b)/b^2;
CXZ=filter2(h,CXZ);
mm=floor(max(max(CXZ+1))); % to fit color map
CXZ=CXZ*ncolor/mm;
CmapXZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapXZ(1,:)=1;  % force background to white
set(gca,'FontSize',16)
image(grille1*1e3,grille3*1e3,CXZ)
colormap(CmapXZ)
set(gca,'YDir','normal')
%xlim([-1  1])
xlabel('X (mm)');ylabel('Z (mm)'); grid on;
grid on
return
 
% 
% color=phasespace(6,:)*100;
% figure(800)
% scatter3(phasespace(5,:)*1e6,phasespace(1,:)*1e6,phasespace(3,:)*1e6,10,color,'.')
% xlabel('S (µm)');ylabel('X (µm)');zlabel('X (µm)');
% %colorbar
% set(gca,'FontSize',16)
% set(gcf,'color','w')
% return

% Scatter color energy
color=phasespace(6,:);
figure(700)
set(gcf,'color','w')
subplot(1,2,1)
 scatter(phasespace(1,:)*1e3,phasespace(2,:)*1e3,20,color,'.')
  xlabel('X (mm)');ylabel('XP (mrad)');
  grid on;
  set(gca,'FontSize',16)
  xlim([-1 1]);ylim([-0.2 0.2])
subplot(1,2,2)
 scatter(phasespace(3,:)*1e3,phasespace(4,:)*1e3,20,color,'.')
 xlabel('Z (mm)'); ylabel('ZP (mrad)');
 grid on ;
  xlim([-1 1]);ylim([-0.2 0.2])
 set(gca,'FontSize',16)
 
 return


