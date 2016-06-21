function [P,Lgsm,betam,Li,gs,Ls,cur,B]=get_Lsat_FEL_slippage_optic(phasespace,qm,Ef,lambda,ond,L,nbin)
% Integrate over nbin slices according Emittance and E-spread to slippage
% P = output power (W) along undulator Li (step=period ond) for each slice gs
% (nbin)  : size P  n_ond * nbin
% cur : current profil
% B magnetic field
% Optic beta varying according to slice

%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,~, s_rms s_emit,cur,s_twiss]=bunch_statistics_slice(phasespace,qm,nbin,2);
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


% Integrate over slice according to slippage 
eta=1/3;            % theoritical slippage ration (=1 for low gain resonance)
ds  =ond;           % step for integration
Li  =(0:ds:L);      % Undulator integration
nstep=length(Li);   % Number of integration step
Ls  =Li*lambda/ond*eta;  % Equivalent slippage over bunch along L undulator
Lt=Ls'*ones(1,nbin)+ones(nstep,1)*gs; % Set of slice slippage position
%extrapval=max(max(Lg));  %
[X,Y] = meshgrid(gs,Li);
Lgs =interp2(X,Y,Lg,Lt,Y,'linear',100); % Set of slice Lgain interpolated over slippage position
bss =interp2(X,Y,bs,Lt,Y,'linear',100); % Set of slice beta interpolated over slippage position
Lgsm=mean(Lgs) ; % Mean Lg along fel propagation
betam=mean(bss); % Mean beta along fel propagation

%Integrate power for slice over undulator length + Saturation cut
P=zeros(nstep,nbin);     % allocate memory
%P(1,:)=1e4*ones(1,nbin); % input power in Watt
P(1,:)=max(max(Pn))*ones(1,nbin)/9;

for i=2:nstep
    Isat=(P(i-1,:)<Psat(i,:));% test saturation for slices at each step (0/1)
    %Isat=1;
    P(i,:)=P(i-1,:)+P(i-1,:)./Lgs(i,:)*ds.*Isat;
end
P(isnan(P))=0;



% figure(100)
% dens=cur./sqrt(bs.*emitts);
% surf(dens,'FaceColor','interp',...
%           'EdgeColor','none',...
%           'FaceLighting','phong')
% axis tight
% view(20,60)
% camlight left
% 
% figure(101)
% surf(1./Lg,'FaceColor','interp',...
%            'EdgeColor','none',...
%             'FaceLighting','phong')
% axis tight
% view(20,60)
% camlight left
% 
% figure(102)
% surf(P,'FaceColor','interp',...
%            'EdgeColor','none',...
%             'FaceLighting','phong')
% axis tight
% view(20,60)
% camlight left

return






