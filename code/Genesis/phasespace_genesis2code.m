function phasespace_genesis2code( filename,phasespace )
%PHASESPACE_GENESIS2CODE Summary of this function goes here

if nargin == 0 ;
    rep        ='/home/loulergue/work/Genesis/LWFA/';
    input_file ='Cas-1mm-Chirp/beam';
    input_file ='LOA-testSM-160nm/beam';
end

M = importdata([rep input_file], ' ', 5);
beam=M.data;
gam0=mean(beam(:,6))
beam(:,6)=(beam(:,6)-gam0)/gam0;
phasespace=beam';

[b_mean b_sig b_emit]=bunch_statistics(phasespace,0);
fprintf('IN data  \n')
fprintf('  b-mean  = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_mean)
fprintf('  b-sig   = %10.3d   %10.3d   %10.3d   %10.3d   %10.3d   %10.3d \n',b_sig)
fprintf('  b-emit  = %10.3d   %10.3d   %10.3d   \n',b_emit*gam0)


figure(10)
plot(beam(:,5),beam(:,6),'.b'); 
grid on

end

