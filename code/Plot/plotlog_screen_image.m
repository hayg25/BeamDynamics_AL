function plotlog_screen_image(g1,g3,CXZ)
% Comput mean, rms  from screen vertical slice 
% nbin    : number of slice
% w half window size x & z

ncolor=power(2,12);
CXZ=log(1+CXZ);
mm=floor(max(max(CXZ+1))); % to fit color map
CXZ=floor(CXZ*ncolor/mm);
CmapXZ=jet(ncolor);
%C(1,:)=0;  % force background to black
CmapXZ(1,:)=1;  % force background to white

figure(200)
set(gcf,'color','w')
set(gca,'FontSize',16)
image(g1*1e3,g3*1e3,CXZ)
colormap(CmapXZ)
set(gca,'YDir','normal')
ylabel('Z (mm)'); 
xlabel('X (mm)'); 
grid on;

return