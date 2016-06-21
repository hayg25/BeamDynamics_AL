function CLS_nomatching_6D(n_period)
% test tracking bunch trought LATTICE
global  LATTICE DYNAMIC

rep ='/home/loulergue/work/matlab/Simulation/beta_structure/';
%input_file ='cls/ThomX-6/CDR_0.15_0.66_r56_0.4_sx_Dff_chro_2_1.str';
%input_file ='cls/ThomX-6/CDR_0.15_0.66_r56_0.2_nosx_Dff_IP.str';
input_file ='cls/ThomX-30-V5/CDR_0.17_0.64_r56_0.3_sx_Dff.str';
lattice_beta2code(rep,input_file)

%
Vrf =0.300;
Frf = 0.5e9; 
phi0=pi/2; 
lattice_add_RF('CAV',50,Vrf,Frf,phi0,55);
%lattice_add_QFF;

%
DYNAMIC.nbin=101;
DYNAMIC.wind=4;
DYNAMIC.filter_mode='average';
DYNAMIC.nbin3=[16 16 16]; % default for SC
DYNAMIC.wind3=1;

%lattice_split(5,'DI')
if nargin==0 ; n_period=1;end

stat='no';  % for plotting only 1 per turn (case many turn)
if n_period==1 ; stat='yes';end

np   =3000;
nplot=10;

%input data from gun
q0=1.0e-9;
sigs=1.2e-3; 
sige_uncor=1e-3;
c=3e8;
nsig=3.;

fprintf('*********************************\n')
%linac data
Frfl = 3000e6;   % freq cavity
kll=2*pi*Frfl/c;
Vrfl = 50;       % energy gain in MeV
phil = -0.0;
% ring data
name=DYNAMIC.file;
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
Vrf =0.300;
Frf = 0.5e9;      % freq cavity
kl=2*pi*Frf/c;
phi0=pi/2;        % synchronous phases (no losses)
DYNAMIC.RF=[Vrf,Frf,phi0];
temp=DYNAMIC.matrix;
r56=temp(5,6);
temp=DYNAMIC.twiss;
twiss=[temp(1,1) temp(1,2) temp(3,3) temp(3,4)];
disp= DYNAMIC.disp;

% out data for TL
fprintf('Longitudinal gun data:\n')
fprintf('   Relative E-spead = %10.5f\n',sige_uncor)
fprintf('   Bunch length     = %10.5f m      or %10.5f ps\n',sigs*[1 1e12/c])

fprintf('Longitudinal linac data:\n')
fprintf('   Frf     = %10.5f  MHz\n',Frfl*1e-6)
fprintf('   V       = %10.5f  MV\n',Vrfl)
fprintf('   phase   = %10.5f  deg\n',phil*180/pi)
fprintf('Longitudinal lattice data @ 0 A:\n')
fprintf('   Frf     = %10.5f  MHz\n',Frf*1e-6)
fprintf('   V       = %10.5f  MV\n',Vrf)
fprintf('   phase   = %10.5f  deg\n',phi0*180/pi)
fprintf('   r56     = %10.5f  m\n',r56)


% Make bunch from input (gun) longitudinal
gam =(E+E0)/E0;
eps =[1 1]*5e-6/gam; % non normalized
long=[sigs sige_uncor];
[phasespace,qm]=bunch_generation(twiss,0*disp,eps,long,np,q0,nsig);
% modelise the linac (RF curvature) and add disp component
[phasespace]=bunch_generation_gun(phasespace,E,E0,Frfl,phil,q0); 
phasespace(1:4,:)=phasespace(1:4,:) + disp(1:4)*phasespace(6,:);
[phasespace]=acceptance(phasespace,6,0.01);% In energy


% Print
[b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
fprintf('Longitudinal input data:\n')
fprintf('   Relative E-spead  = %10.5f\n',b_sig(6))
fprintf('   Bunch length      = %10.5f m      or %10.5f ps\n',b_sig(5)*[1 1e12/c])
% Match ring
slope=sqrt(- r56 * E / (kl*Vrf*sin(phi0)));
sigsr=b_sig(6)*slope;
fprintf('   Ring Bunch length = %10.5f m      or %10.5f ps\n',sigsr*[1 1e12/c])

%
fprintf('########  Program1 ########\n')
fprintf('beta file   : %s\n',name)
fprintf('Elements nb : %d\n',length(LATTICE))

fprintf('Energy      : %10.3f  MeV\n',E)
fprintf('Charge      : %10.3f  nC\n',q*1e9)
nus=get_tune;
fprintf('Tunes x,z,s,: %4.2f  %4.2f  %4.2f \n',nus)


fprintf('IN data  %10.3f nC \n',q*1.e9)
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit*gam)


% track
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
nnp=0;
nelem=length(LATTICE);
%pelem=35+12*1;% for ploting data at element pelem
%pelem=19;% for ploting data at element pelem
centre=[]; sigma=[]; emit=[];charge=[];
for i=1:n_period
    
    %[phasespace,c s e]=track_bunch_LIN(phasespace,nelem,stat);
    %[phasespace,c s e,grille,profil,waket]=track_bunch(phasespace,nelem,stat);
    [phasespace,q,c,s,e,grille,profil,waket]=track_bunch_wake(phasespace,E,E0,qm,nelem,stat);
    centre=[centre c]; sigma=[sigma s]; emit=[emit e];charge=[charge q];
    %
    [phasespace]=acceptance(phasespace,6,0.02);% In energy
    [phasespace]=acceptance(phasespace,5,0.040);% In long pos
    
    %plot online
    nnp=nnp+1;
    if nnp==nplot
        
        figure(100)
        set(gca,'FontSize',14)
        subplot(3,1,1)
        plot(grille*1e3,profil,'-b');
        xlim([-30 30])
        grid on
        title(['Longitudinal phase # ' num2str(i)])
        
        subplot(3,1,2)
        plot(phasespace(5,:)*1e3,phasespace(6,:)*1e2, '.b') ;
        xlabel('s (mm)');ylabel('de/e')
        xlim([-30 30])
        ylim([-2 2])
        grid on
        
        subplot(3,1,3)
        plot(grille*1e3,waket,'-b');
        grid on

        nnp=0;
        
        figure(2)
        plot(emit(1,:),'-r');
        xlabel('Tours');ylabel('Emit H (m.rad)');
        grid on
        
        m2ps=1e12/3e8;
        figure(3)
        plot(centre(5,:)*m2ps,'-k');
        xlabel('Tours');ylabel('Length rms (ps)');
        grid on
        
    end

end
toc

[b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
fprintf('OUT data  %10.3f nC \n',q*1.e9)
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit*gam)

% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot_6D_tracking(phasespace,centre,sigma,emit,n_period,stat)


return
% save
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% store data traking
dir='data_TDR.1/';
fic='CLS_nomatching_VesselCSRwake_RFphase_1.0nC.chro_0_0.mat';
file=[dir fic];

%
DYNAMIC.Nturn=n_period;
DYNAMIC.np=np;
DYNAMIC.q0=q0;
DYNAMIC.sigs=sigs;
DYNAMIC.sige_uncor=sige_uncor;
DYNAMIC.nsig=nsig;
DYNAMIC.E=E;
DYNAMIC.E0=E0;
DYNAMIC.Frf=Frf;
DYNAMIC.Vrf=Vrf;
DYNAMIC.phi0=phi0;
DYNAMIC.eps=eps;
DYNAMIC.long=long;
%
TRACK.charge=charge;
TRACK.centre=centre;
TRACK.sigma=sigma;
TRACK.emit=emit;
TRACK.waket=waket;

save(file,'DYNAMIC','TRACK','phasespace0','phasespace')

fprintf('Data saved in %s\n',file)


