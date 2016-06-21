function [phasespace,centre,sigma,emit,grille,profil,waket]=track_bunch(phasespace,pelem,arg)
% Tracking bunch trought LATTICE based on coordinates :
%    Pos in meter   :  x,z,l 
%    and associated :  xp=Px/P  zp=Pz/P  d=(P-P0)/P0
%    with P total momentum (eV/c)
%
% non_linear + possible rand off set
%
global  LATTICE DYNAMIC
%
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
gam =(E+E0)/E0;
%
SR='off';  % default
if isfield( DYNAMIC, 'SR'); SR= DYNAMIC.SR ; end
%
stat='yes'; % for cumulate out data  : centre sigma emit
if nargin == 3 ;stat=arg;end

%    
% At beginning
elem1=1;
nelem=length(LATTICE);
if strcmp(stat,'yes')
    disp= DYNAMIC.disp;
    [b_mean, b_sig, b_emit]=bunch_statistics(phasespace,0,disp);
    centre=b_mean;sigma =b_sig;emit  =b_emit;
    nelem=pelem;
    if length(pelem)==2; %to track from 
        elem1=pelem(1);
        nelem=pelem(2);
    end
end
grille=0;
profil=0;
waket =0;


% Track from 1 to nelem
for i=elem1:nelem
    type=LATTICE(i).type;
    T   =LATTICE(i).matrix;
    L   =LATTICE(i).length;
    K   =LATTICE(i).strength;
%     ksi =LATTICE(i).chro;
    disp=LATTICE(i).disp;
    err =LATTICE(i).err;
    flag=LATTICE(i).flag;
    %
    errflag=length(err)>1;
    % Test for err
    if errflag
        phasespace(1,:)=phasespace(1,:)-err(1,1);
        phasespace(3,:)=phasespace(3,:)-err(1,2);
        phasespace=matrix_rotation(-err(1,3))*phasespace;
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
    elseif strcmp(type,'ID')
        % Case exact integration
        [phasespace]=pass_ID(phasespace,K,L);    
    elseif strcmp(type,'HC')
        % Then H corrector
        [phasespace]=pass_HC(phasespace,K);   
    elseif strcmp(type,'VC')
        % Then V corrector
        [phasespace]=pass_VC(phasespace,K);    
    elseif strcmp(type,'SF')
        % Then electrical thin lens pass
        [phasespace]=pass_ELENS(phasespace,K);  
    else
        phasespace=T*phasespace;
%         [phasespace]=Chro_pass(phasespace,ksi);
%         [phasespace]=length_pass(phasespace,L);
    end
    %
    % Linear lenthening vs speed
    phasespace(5,:)=phasespace(5,:) + (phasespace(6,:)/gam^2)*L;
    %
    % Test for err
    if errflag
        phasespace(1,:)=phasespace(1,:)+err(1,1);
        phasespace(3,:)=phasespace(3,:)+err(1,2);
        phasespace=matrix_rotation(err(1,3))*phasespace;
    end
    %
    % test for plot
    if strcmp(stat,'yes')
        [b_mean, b_sig, b_emit]=bunch_statistics(phasespace,0,disp);
        centre=[centre b_mean];
        sigma= [sigma b_sig];
        emit = [emit b_emit];
    else
        if i==pelem
            [b_mean, b_sig, b_emit]=bunch_statistics(phasespace,0,disp);
            centre=b_mean;
            sigma =b_sig;
            emit  =b_emit;
        end
    end
end
return