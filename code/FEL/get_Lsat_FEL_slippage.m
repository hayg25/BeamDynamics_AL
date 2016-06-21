function [P,Li,gs,Ls,cur,B]=get_Lsat_FEL_slippage(phasespace,qm,Ef,lambda,ond,beta,L,nbin)
% Integrate over nbin slices according Emittance and E-spread to slippage
% P = output power along undulator Li (step=period ond) for each slice gs
% (nbin)  : size P  n_ond * nbin
% cur : current profil
% B magnetic field
% Optic beta fixed to mean value along undulator

%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
[gs,s_mean s_rms s_emit,cur,s_twiss]=bunch_statistics_slice(phasespace,qm,nbin);
gam=Ef/0.511;
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

% Get slice FEL data (assumed constant along undulator : optic fixed)
[~, ~, Psat,~,Lg,~,Pn,~,B] = get_Lsat_FEL(lambda,ond,emitts,des,cur,beta,Ef);
% fprintf('\n')
% fprintf('From Ming-Xie FEL at %5.2d m with periode %5.2d m \n',lambda,ond)
% fprintf('   FEL Lsat1d = %5.2d m  Psat1d = %5.2d W  \n',min(Lsat1d),max(Psat1d))
% fprintf('   FEL Lsat   = %5.2d m  Psat   = %5.2d W  \n',min(Lsat),  max(Psat))

% Integrate over slice according to slippage 
eta=1/3;          % theoritical slippage ration (=1 for low gain resonance)
ds  =ond;           % step for integration
Li  =(0:ds:L);      % Undulator integration
nstep=length(Li);   % Number of integration step
Ls  =Li*lambda/ond*eta;  % Equivalent slippage over bunch along L undulator
Lt=Ls'*ones(1,nbin)+ones(nstep,1)*gs; % Set of slice slippage position
extrapval=max(Lg);  %
Lgs =interp1(gs,Lg,Lt,'linear',extrapval); % Set of slice Lgain interpolated over slippage position
%P=Pn/9;              % input power in Watt
%Psats=interp1(gs,Psat,Lt);% Psat across slippage and slice


%Integrate power for slice over undulator length + Saturation cut
P=zeros(nstep,nbin);% allocate memory
%P(1,:)=Pn/9; % input power in Watt
P(1,:)=max(Pn)*ones(1,nbin)/9;
for i=2:nstep
    Isat=(P(i-1,:)<Psat);% test saturation for slices at each step (0/1)
    P(i,:)=P(i-1,:)+P(i-1,:)./Lgs(i,:)*ds.*Isat;
end

return






