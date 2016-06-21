function ThomX_ring(n_period)
% test tracking bunch trought LATTICE
global  LATTICE DYNAMIC
%
rep ='/home/sources/physmach/loulergue/work/code/BETA-structure/';
input_file ='ThomX_0.17_0.64_r56_0.2_sx_Dff.str';
lattice_beta2code(rep,input_file)
lattice_add_RF('RF',DYNAMIC.energy,0.3,500e6,pi/2,55);

% For wake field 
DYNAMIC.nbin=101;
DYNAMIC.wind=4;
DYNAMIC.filter_mode='averageg';
DYNAMIC.SR='off';
%
%lattice_split(5,'DI')
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
gam =(E+E0)/E0;
eps =[1  1]*3e-6/gam;                                 % geometric
temp=DYNAMIC.twiss;
twiss=[temp(1,1) temp(1,2) temp(3,3) temp(3,4)];
long=[0.004 0.001];
disp= DYNAMIC.disp;
%
fprintf('########  Program1 ########\n')
fprintf('beta file   : %s\n',name)
fprintf('Elements nb : %d\n',length(LATTICE))

fprintf('Energy      : %10.3f  MeV\n',E)
fprintf('Charge      : %10.3f  nC\n',q0*1e9)
%
[phasespace,qm]=bunch_generation(twiss,disp,eps,long,np,q0,3);
[b_mean, b_sig, b_emit]=bunch_statistics(phasespace,qm,disp);
%
fprintf('IN data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit)

%
% Track
tic
nelem=length(LATTICE);
centre=[]; sigma=[]; emit=[];
for i=1:n_period
    %[phasespace,c, s,e]=track_bunch_LIN(phasespace,nelem,stat);
    [phasespace,c, s, e]=track_bunch(phasespace,nelem,stat);
    %[phasespace,q,c,s,e]=track_bunch_wake(phasespace,E,E0,qm,nelem,stat);
    centre=[centre c]; sigma=[sigma s]; emit=[emit e];
end
toc

%
[b_mean, b_sig, b_emit]=bunch_statistics(phasespace,qm,disp);
fprintf('OUT data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
plot_6D_tracking(phasespace,centre,sigma,emit,n_period,stat)
return



