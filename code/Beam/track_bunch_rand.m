function [phasespace,centre,sigma,emit,grille,profil,waket]=track_bunch_rand(phasespace,pelem,arg)
% Tracking bunch trought LATTICE
% non_linear + possible rand off set
global  LATTICE DYNAMIC
%
E   =DYNAMIC.energy;
%
SR='off';  % default
if isfield( DYNAMIC, 'SR'); SR= DYNAMIC.SR ; end
%
stat='yes'; % for cumulate out data  : centre sigma emit
if nargin == 3 ;stat=arg;end

%    
% at beginningn
elem=length(LATTICE);
if strcmp(stat,'yes')
    disp= DYNAMIC.disp;
    [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
    centre=b_mean;
    sigma =b_sig;
    emit  =b_emit;
    nelem=pelem;
end
grille=0;
profil=0;
waket =0;


% track from 1 to nelem
for i=1:nelem
    type=LATTICE(i).type;
    T   =LATTICE(i).matrix;
    L   =LATTICE(i).length;
    K   =LATTICE(i).strength;
    ksi =LATTICE(i).chro;
    Disp=LATTICE(i).disp;
    err =LATTICE(i).err;
    flag=LATTICE(i).flag;
    %
    errflag=length(err)>1;
    % Test for err
    if errflag
        phasespace(1,:)=phasespace(1,:)-err(1,1);
        phasespace(3,:)=phasespace(3,:)-err(1,2);
    end
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
     elseif strcmp(type,'MULT')
        [phasespace]=pass_mult(phasespace,K);       
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
    elseif strcmp(type,'ID1')
        % Case exact integration
        [phasespace]=pass_ID(phasespace,K,L);    
    elseif strcmp(type,'HC')
        % Then H corrector
        [phasespace]=pass_HC(phasespace,K);   
    elseif strcmp(type,'VC')
        % Then V corrector
        [phasespace]=pass_VC(phasespace,K);           
    else
        phasespace=T*phasespace;
%         [phasespace]=Chro_pass(phasespace,ksi);
%         [phasespace]=length_pass(phasespace,L);
    end
    %
    % Test for err
    if errflag
        phasespace(1,:)=phasespace(1,:)+err(1,1);
        phasespace(3,:)=phasespace(3,:)+err(1,2);
    end
    %
    % test for plot
    if strcmp(stat,'yes')
        disp=LATTICE(i).disp;
        [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
        centre=[centre b_mean];
        sigma= [sigma b_sig];
        emit = [emit b_emit];
    else
        if i==pelem
            disp=LATTICE(i).disp;
            [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
            centre=b_mean;
            sigma =b_sig;
            emit  =b_emit;
        end
    end
end
return