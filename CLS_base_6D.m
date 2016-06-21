function CLS_base_6D(n_period)
% test tracking bunch trought LATTICE
global  LATTICE DYNAMIC
%
rep ='/home/loulergue/work/matlab/Simulation/beta_structure/';
input_file ='cls/ThomX-30-V5/CDR_0.17_0.64_r56_0.3_sx_Dff.str';
lattice_beta2code(rep,input_file)
Vrf =0.300;Frf = 0.5e9; phi0=pi/2; 
lattice_add_RF('CAV',50,Vrf,Frf,phi0,55);
%element_add_QFF;

%
DYNAMIC.nbin=501;
DYNAMIC.wind=2;
DYNAMIC.filter_mode='averageg';
DYNAMIC.SR='off';
%
lattice_split(0.05)
%
if nargin==0 ; n_period=1;end
%
stat='no';  % for plotting only 1 per turn (case many turn)
if n_period==1 ; stat='yes';end
% 
% Make bunch from input
q0  =1.0e-9;
np  =3000;
name=DYNAMIC.file;
E   =DYNAMIC.energy;
E0  =DYNAMIC.restmass;
disp=DYNAMIC.disp;
gam =(E+E0)/E0;
eps =[1  1]*5e-6/gam;                                 % geometric
temp=DYNAMIC.twiss;
twiss=[temp(1,1) temp(1,2) temp(3,3) temp(3,4)];
T=DYNAMIC.matrix;
sige=3e-3;
[sigs,~,corr]=get_beam_long2(sige,T(5:6,5:6));
long=[sigs sige corr];
nsig=3.;
%
fprintf('########  Program1 ########\n')
fprintf('beta file   : %s\n',name)
fprintf('Elements nb : %d\n',length(LATTICE))
fprintf('Energy      : %10.3f  MeV\n',E)
fprintf('Charge      : %10.3f  nC\n',q0*1e9)
%
[phasespace,qm]=bunch_generation(twiss,disp,eps,long,np,q0,nsig);
[b_mean b_sig b_emit q]=bunch_statistics(phasespace,qm,disp);
fprintf('IN data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit)
%
% track
tic
nelem=length(LATTICE);
centre=[]; sigma=[]; emit=[]; FBT=[];
for i=1:n_period
    %[phasespace,c s e]=track_bunch_LIN(phasespace,nelem,stat);
    %[phasespace,c s e]=track_bunch(phasespace,nelem,stat);
    [phasespace,q,c,s,e]=track_bunch_wake(phasespace,E,E0,qm,nelem,stat);
    centre=[centre c]; sigma=[sigma s]; emit=[emit e];
   
end
toc
%
[b_mean b_sig b_emit]=bunch_statistics(phasespace,qm,disp);
fprintf('OUT data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
plot_6D_tracking(phasespace,centre,sigma,emit,n_period,stat)
return

%
