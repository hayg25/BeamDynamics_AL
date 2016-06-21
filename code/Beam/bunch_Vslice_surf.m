function [x,s_q,s_mean,s_rms]=bunch_Vslice_surf(phasespace,nbin,w,dx)
% Comput mean, rms  from screen vertical slice 
% nbin    : number of slice
% w half window size x & z
% data are table of size (param,nbin)
% s_mean  : mean of the 6 variables  (6,nbin)
% s_rms   : std of the 6 variables   (6,nbin)

phimax1=w(1);
[phasespace]=acceptance(phasespace,1,phimax1);
phimax3=w(2);
[phasespace]=acceptance(phasespace,3,phimax3);

% X Z plane
% Mesh over X
phi1=phasespace(1,:);
step1=(2*phimax1)/nbin;
grille1=(-phimax1:step1:phimax1) + 0*mean(phi1);

% Mesh over Z
phi3=phasespace(3,:);
step3=(2*phimax3)/nbin;
grille3=(-phimax3:step3:phimax3) + 0*mean(phi3);

% imported from the net
[CXZ] = hist2(phi1,phi3,grille1,grille3);
b=2;h=ones(b)/b^2;
CXZ=filter2(h,CXZ);
n=length(grille1);
CXZ=CXZ(1:n,1:n);

%Get sum, mean and rms on vertical
s_q=sum(CXZ); 
Z=(ones(n,1)*grille3)';
s_mean=mean(CXZ.*Z)./s_q*nbin;
Zm=(ones(n,1)*s_mean);
s_rms=mean(CXZ.*(Z-Zm).^2)./s_q*nbin;
s_rms=sqrt(s_rms);

ncolor=power(2,12);
mm=floor(max(max(CXZ+1))); % to fit color map
CXZ=CXZ*ncolor/mm;
CmapXZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapXZ(1,:)=1;  % force background to white

x=grille1;
grille1=grille1*1e3;
grille3=grille3*1e3;
xl=[-phimax1 phimax1]*1e3;
if  nargin==4; % converte mm to %
    grille1=grille1/dx/10;
    xl= xl/dx/10;
end

figure(1)
set(gcf,'color','w')
subplot('position',[.1 .61 .85 .35])
set(gca,'FontSize',16)
image(grille1,grille3,CXZ)
xlim(xl)
colormap(CmapXZ)
set(gca,'YDir','normal')
set(gca,'XTickLabel',[])
ylabel('Z (mm)'); grid on;

subplot('position',[.1 .34 .85 .25])
set(gca,'FontSize',16)
plot(grille1,s_q(1:n),'LineWidth',2)
xlim(xl)
set(gca,'XTickLabel',[])
ylabel('Density (u.a.)'); grid on;

subplot('position',[.1 .07 .85 .25])
set(gca,'FontSize',16)
plot(grille1,s_rms(1:n)*1e3,'LineWidth',2)
xlim(xl)
xlabel('X (mm)');ylabel('Z rms (mm)'); grid on;

return