function [Lg,gs,cur,B]=get_Lsat_FEL_slice_optic(phasespace,qm,Ef,lambda,ond,L,nbin)
% Get slice FEL data along undulator vs Emittance, size and E-spread 
% (nbin)  : size P  n_ond * nbin
% cur : current profil
% B magnetic field
% Optic beta varying according to slice

%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,~, s_rms, s_emit,cur,s_twiss]=bunch_statistics_slice(phasespace,qm,nbin,2);
emitxs =s_emit(1,:);
emitzs =s_emit(2,:);
des    =s_rms(6,:);

% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;
emitts =sqrt(emitxs.*emitzs); % mean geometric emittance

% Get the varying beta for each slice
[bxs,bzs] = get_slice_optic(s_twiss,Ef,lambda,ond,L);
bs =sqrt(bxs.*bzs); % mean geometric beta
% Match the dimension (add the additionnal beta variation)
n=size(bs);n1=n(1);
cur=ones(n1,1)*cur;
des=ones(n1,1)*des;
emitts=ones(n1,1)*emitts;

% Get slice FEL data along undulator
[Lsat, ~, Psat,~,Lg,~,Pn,~,B] = get_Lsat_FEL(lambda,ond,emitts,des,cur,bs,Ef);

return
% plot
figure(100)
dens=cur./(bs.*emitts)*1e-9;
surf(dens,'FaceColor','interp',...
          'EdgeColor','none',...
          'FaceLighting','phong')
axis tight
view(20,60)
camlight left
title('Cur dens in kA/mm2')

figure(101)
surf(1./Lg,'FaceColor','interp',...
           'EdgeColor','none',...
            'FaceLighting','phong')
axis tight
view(20,60)
camlight left
title('1∕Lg in m-1')



return






