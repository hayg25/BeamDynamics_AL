function plot3D_6D_trans_ellips(phasespace,qm,Ef,nbin)
% Plot long profile

gam=Ef/0.511;
Nsigma = 4;
grid_points = nbin;
%
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)-mean(phasespace(6,:));
% sur slices
% get ps data
s_rms = std(phasespace(6,:));
% grid for longitudinal slices
grille = linspace(-Nsigma*s_rms,Nsigma*s_rms,grid_points)';
% binning for the slice parameters
[A,bin] = histc(phasespace(6,:),grille);

ws=[] ;emitxs=[];emitzs=[];des=[];
bxs=[];axs=[];bzs=[];azs=[];
for i=1:grid_points
    num_par = length(find(bin==i));
    if(num_par >= 5)
        slicephase = phasespace(:,find(bin==i));
        %[x,b_mean,b_rms,b_emit,b_twiss,weight] = beam_statistics(slicephase);
        [b_mean b_rms b_emit]=bunch_statistics(slicephase,0);
        emitxs =[emitxs  b_emit(1)];
        emitzs =[emitzs  b_emit(2)];
        des    =[des     b_rms(6)];
        ws     =[ws      num_par];
    else
        ws     =[ws      0];
        emitxs =[emitxs  0];
        emitzs =[emitzs  0];
        des    =[des     0];
    end
end
cur=(ws/(2*Nsigma*s_rms)*grid_points*3e08)*qm;
gs=2*Nsigma*s_rms*( (1:grid_points)-grid_points/2 )/grid_points;


% Smoothing working
windowSize = 5;
smooth=filter(ones(1,windowSize)/windowSize,1,cur);cur=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,des);des=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitxs);emitxs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,emitzs);emitzs=smooth;
smooth=filter(ones(1,windowSize)/windowSize,1,Bs);Bs=smooth;

