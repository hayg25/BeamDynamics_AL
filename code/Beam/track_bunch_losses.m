function [phasespace,centre,sigma,emit,loss,flag]=track_bunch_losses(phasespace,w)
% Tracking bunch trought LATTICE
% non_linear
global  LATTICE DYNAMIC
%
%
SR='off';  % default
if isfield( DYNAMIC, 'SR'); SR= DYNAMIC.SR ; end
%
disp= DYNAMIC.disp;
[b_mean, b_sig, b_emit]=bunch_statistics(phasespace,0,disp);
centre=b_mean;
sigma =b_sig;
emit  =b_emit;
loss  = 0;

%
nelem=length(LATTICE);
% track from 1 to nelem
for i=1:nelem
    type=LATTICE(i).type;
    T   =LATTICE(i).matrix;
    L   =LATTICE(i).length;
    K   =LATTICE(i).strength;
    ksi =LATTICE(i).chro;
    Disp=LATTICE(i).disp;
    pipe=LATTICE(i).pipe;
    flag=LATTICE(i).flag;
    %
    if     strcmp(type,'RF')
        RF=DYNAMIC.RF;           % Vrf,Frf,phi
        [phasespace]=pass_RF(phasespace,E,RF(1),RF(2),RF(3));
    elseif strcmp(type,'SD')
        [phasespace]=pass_drift(phasespace,L);
    elseif strcmp(type,'SX')
        [phasespace]=pass_SX(phasespace,K*L);
    elseif strcmp(type,'QFF')
        [phasespace]=pass_QFF(phasespace,K);
    elseif strcmp(type,'DI')
        % Case exact integration
        %[phasespace]=dipole_geom_pass(phasespace,L,K);
        [phasespace]=pass_dipole(phasespace,L,K);
        if strcmp(SR,'on');[phasespace]=SR_kick(phasespace,E,K,L);end
    elseif strcmp(type,'CO')
        % Case exact integration
        [phasespace]=pass_CO(phasespace,K,-flag);
    elseif strcmp(type,'QP')
        % Case exact integration
        [phasespace]=pass_QP(phasespace,K,L);
    else
        phasespace=T*phasespace;
%         [phasespace]=Chro_pass(phasespace,ksi);
%         [phasespace]=length_pass(phasespace,L);
    end

    % Test for losses
    [phasespace,nloss,flag]=get_losses(phasespace,pipe,w);
    if flag==1; break; end
    loss= [loss nloss];
    
    %
    disp=LATTICE(i).disp;
    [b_mean, b_sig, b_emit]=bunch_statistics(phasespace,0,disp);
    centre=[centre b_mean];
    sigma= [sigma b_sig];
    emit = [emit b_emit];

    
end
return