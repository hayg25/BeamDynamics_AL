%%
clear
global  LATTICE DYNAMIC
rep ='/home/sources/physmach/loulergue/work/code/BETA-structure/';
%input_file ='COX180MeV-200nm-1U20-2m-S2I-SM1.str';
%input_file ='COX180MeV-200nm-1U15-3m-S2I-SM1.str';
input_file ='COX400MeV-040nm-1U15-3m-S2I-SM1.str';
lattice_beta2code(rep,input_file)
%lattice_split(0.1);
%
r56=0; % No chicane in the lattice
%
% Make bunch from input
q   =0.034e-9;
np  =300000;
name=DYNAMIC.file;
E   =DYNAMIC.energy;
%
E0  =DYNAMIC.restmass;
gam =(E+E0)/E0;
eps =[1  1]*1e-6/gam;        % geometric
long=[1e-6 0.01];
%
fprintf('########  Program1 ########\n')
fprintf('beta file   : %s\n',name)
fprintf('Elements nb : %d\n',length(LATTICE))
fprintf('Energy      : %10.3f  MeV\n',E)
fprintf('Charge      : %10.3f  nC\n',q*1e9)
fprintf('r56         : %10.3f  mm\n',r56*1e3)

%% Generate beam
% To fix 1 mrad in both plane
div0=1.e-3;
temp=DYNAMIC.twiss;
r=eps(1)*temp(2,2)/(div0)^2;
twiss=[temp(1,1)*r temp(1,2) temp(3,3)*r temp(3,4)];
disp= DYNAMIC.disp;
[phasespace,qm]=bunch_generation(twiss,disp,eps,long,np,q);
[b_mean, b_sig, b_emit,q,b_twiss]=bunch_statistics(phasespace,qm,disp);
fprintf('IN data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit*gam)

%% Analytical Track
ond=0.015;Lond=3;lambda=40e-9;Nond=Lond/ond;
M=DYNAMIC.matrix;[dM]=get_matrix_2nd;
r11 =M(1,1);r126=dM(1,2);
r33 =M(3,3);r346=dM(3,4);
temitx= gam*sqrt(eps(1)^2 + (r126/r11*div0^2*long(2))^2);
temitz= gam*sqrt(eps(2)^2 + (r346/r33*div0^2*long(2))^2);
r56x=-r11*r126*lambda/ond/3;
r56z=-r33*r346*lambda/ond/3;
dex =abs(Lond/r11/r126/2);
dez =abs(Lond/r33/r346/2);


%% Track
nelem=length(LATTICE);
centre=[]; sigma=[]; emit=[];
%[phasespace,c s e]=track_bunch_LIN(phasespace,nelem);
[phasespace,c s e]=track_bunch(phasespace,nelem);
%[phasespace,q,c,s,e]=track_bunch_wake(phasespace,E,E0,qm,nelem,stat);
centre=[centre c]; sigma=[sigma s]; emit=[emit e];
%
phasespace(5,:)=phasespace(5,:) + 4*r56x*phasespace(6,:);
%
[b_mean b_sig b_emit]=bunch_statistics(phasespace,qm);
fprintf('OUT data  \n')
fprintf('Energy      : %10.3f  MeV\n',LATTICE(nelem).energy(1))
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit*gam)

fprintf('Out data  analytic\n')
fprintf('  b-emitN = %10.3d   %10.3d     \n',temitx,temitz)
fprintf('  r11 33  = %10.3d   %10.3d     \n',r11,r33)
fprintf('  r126 346= %10.3d   %10.3d     \n',r126,r346)
fprintf('  r56     = %10.3d   %10.3d     \n',r56x,r56z)
fprintf('  de max  = %10.3d   %10.3d     \n',dex,dez)

%% plot
%plot_6D_long_profile_surf(phasespace,qm,E,201)
%plot_6D_long_profile_surf(phasespace,qm,E,201)
%plot_6D_trans_profile(phasespace)
plot_6D_trans_profile_surf(phasespace,qm,E,201)

return

%
[K,aw,B] = get_und_param(E,lambda,ond);
T=matrix_ID(-Lond/2,K);
phasespace=T*phasespace;
plot_slice_und(phasespace,K,ond,Nond,qm,101,2)

