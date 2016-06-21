function [gx,s_mean s_rms s_q]=bunch_Vslice(phasespace,nbin,Nsigma)
% Comput mean, rms  from screen vertical slice 
% nbin    : number of slice
% data are table of size (param,nbin)
% s_mean  : mean of the 6 variables  (6,nbin)
% s_sig   : std of the 6 variables   (6,nbin)


if nargin<3 ; Nsigma = 3 ; end
%
ns=1;
phasespace(ns,:)=phasespace(ns,:)-mean(phasespace(ns,:));

% get ps data
s_rms0 = std(phasespace(ns,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms0,Nsigma*s_rms0,nbin)';
% binning for the slice parameters
[A,bin] = histc(phasespace(ns,:),grille);

% Over slices in verical
s_mean=zeros(1,nbin); s_rms=s_mean; s_q=s_mean;
for i=1:nbin
    num_par = length(find(bin==i));
    if(num_par >= 5)
        slicephase = phasespace(:,find(bin==i));
        s_q(i)=length(slicephase(3,:));
        s_mean(i)=mean(slicephase(3,:));
        s_rms(i)=std(slicephase(3,:));
    end
end
gx=grille;
return

% figure(1)
% subplot(3,1,1)
% set(gca,'FontSize',16)
% plot(phasespace(1,:)*1e3,phasespace(3,:)*1e3,'.','MarkerSize',0.01)
% xlabel('X (mm)');ylabel('Z (mm)'); grid on;
% 
% subplot(3,1,2)
% set(gca,'FontSize',16)
% plot(gx*1e3,s_q,'LineWidth',2)
% set(gca,'Yticklabel',[])
% xlabel('X (mm)');ylabel('Density (u.a.)'); grid on;
% 
% subplot(3,1,3)
% set(gca,'FontSize',16)
% plot(gx*1e3,s_rms*1e3,'LineWidth',2)
% xlabel('X (mm)');ylabel('Z rms (mm)'); grid on;
% 
% % figure(2)
% % subplot(2,1,1)
% % plot(gx,s_q)
% % 
% % subplot(2,1,2)
% % plot(gx,s_rms)
% return