function [phasespace,charge,centre,sigma,emit,grille,profil,wakec]=track_bunch_wake(phasespace,E,E0,qm,pelem,arg)
% test tracking bunch trought LATTICE
% include some wake & non_linear
global  LATTICE DYNAMIC
%
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
gam =(E+E0)/E0;
%
SR='off';if isfield( DYNAMIC, 'SR'); SR= DYNAMIC.SR ; end
% for cumulate out data  : centre sigma emit
stat='yes';if nargin == 6; stat=arg;end

disp= DYNAMIC.disp;
[b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
%    
% at beginning
if strcmp(stat,'yes')
    disp= DYNAMIC.disp;
    [b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
    centre=b_mean;
    sigma =b_sig;
    emit  =b_emit;
    charge=q;
end
grille=0;
profil=0;
waket=0;

% Simple model of turn by turn  energy feedback on RF phase

% % Get saved data from ThomX model : BB R L special RF
% dirname='/home/loulergue/work/matlab/code/data/';
% element={'cavplustaper'};
% number =[1];
% len=length(element);
% BBrf=[];Rrf=0;Lrf=0;
% for i=1:len
%     fichier=[dirname 'model_ThomX_zLfit_' element{i} '.mat'];
%     load(fichier, 'BB', 'Rr', 'Li')
%     BB(:,1)=BB(:,1)*number(i); % on resistance Rr
%     BBrf=[BBrf ; BB];
%     Rrf=Rrf+Rr*number(i);
%     Lrf=Lrf+Li*number(i);
% end

wakec=0;

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
    flag=LATTICE(i).flag;

    % tracking part
    if     strcmp(type,'RF')
        RF=DYNAMIC.RF;                     % Vrf,Frf,phi
        RF(3)=pi/2+b_mean(6)*E/RF(1)/50;  % for 1% efficency
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
    %
    % Test for wake
    if (L > 0 ) % apply wake for L>0
        % Get binning
        [profil,grille,phimin,nbin,step,sigs]=get_profile(phasespace,5);
        waket=(1:length(grille))*0;
        % LSC at each stop
        %[wake]=LSC_wake(profil,grille,phimin,qm,nbin,E,E0,L,phasespace); waket=waket+wake;
        %[phasespace] = SC3D_kick(phasespace,q,E,E0,L);
        % RW at each stop
        %[wake]=RW_wake(profil,grille,phimin,qm,nbin,step,5.8e7,0.014,L);waket=waket+wake;
        % CSR in bend
        if strcmp(type,'DI');
            R=abs(K(1)); % get radius
            [wake]=CSR_shielded_wake(profil,grille,phimin,qm,nbin,step,sigs,R,0.014,L);waket=waket+wake;
            %[wake]=CSR_wake(profil,grille,phimin,qm,nbin,step,R,L);waket=waket+wake;
        end
         % Apply wake
        [phasespace] = get_kick(phasespace,grille,waket,E);
        wakec=wakec+waket;
    end

%     if strcmp(type,'RF')
%         [profil,grille,phimin,nbin,step,sigs]=get_profile(phasespace,5);
%         waket=(1:length(grille))*0;
%         [wake]=BB_wake(profil,grille,phimin,qm,nbin,BBrf);waket=waket+wake;
%         [wake]=RL_wake(profil,qm,step,Rrf,Lrf);           waket=waket+wake;
%         [phasespace] = get_kick(phasespace,grille,waket,E);
%         wakec=wakec+waket;
%     end
   
    
    %
    % test for plot
    if strcmp(stat,'yes')   
        disp=LATTICE(i).disp;
        [b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
        centre=[centre b_mean];
        sigma= [sigma b_sig];
        emit = [emit b_emit]; 
        charge=[charge q]; 
    else
        if i==pelem     
            disp=LATTICE(i).disp;
            [b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
            centre=b_mean;
            sigma =b_sig;
            emit  =b_emit;
            charge=q;
        end
    end
    
end

return