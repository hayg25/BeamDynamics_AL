function plot_6D_trans_profile_pipe(phasespace,qm,Ef,nbin,px,pz)
% Plot front view in pipe half size  = px pz in mm

%nsig=3;
ncolor=4096;


figure(600)
set(gcf,'colormap',[])
% X Z plane
% Mesh over X
phi1=phasespace(1,:);
% phimax1=nsig*std(phi1);
phimax1=px*1e-3;
% Mesh over Z
phi3=phasespace(3,:);
%phimax3=nsig*std(phi3);
phimax3=pz*1e-3;
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
b=4;h=ones(b)/b^2;
CXZ=filter2(h,CXZ);
mm=floor(max(max(CXZ+1))); % to fit color map
CXZ=CXZ*ncolor/mm;
CmapXZ=jet(ncolor);
CmapXZ(1,:)=1;  % force background to white
set(gca,'FontSize',16)
image(grille1*1e3,grille3*1e3,CXZ)
colormap(CmapXZ)
set(gca,'YDir','normal')
xlim([-px  px]);ylim([-pz  pz]);
xlabel('X (mm)');ylabel('Z (mm)'); grid on;
grid on



figure(601)
surf(CXZ,'FaceColor','interp',...
          'EdgeColor','none',...
          'FaceLighting','phong')
 colormap(CmapXZ)
 axis tight
 axis off
 return


