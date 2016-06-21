%function plot_genesis_fld
%PLOT_GENESIS_OUTPUT Summary of this function goes here
%   Detailed explanation goes here
clear
rep        ='/home/sources/physmach/loulergue/work/matlab/code/Genesis/LWFA/';
input_file ='COX-200nm-Chirp-SEED/gen.out.dfl';

ncar=251;
nslice=400;

intensity=get_genesis_fld([rep input_file],ncar,nslice);

% Get max of tranverse over slice
intmax=max(intensity,[],3);
intmax=max(intmax,[],2);
[~, imax]=max(intmax);

figure(1)
plot(intmax)


ncolor=128;
%sintensity=squeeze(intensity(imax,:,:));
tintensity=squeeze(sum(intensity));
maxs=max(max(tintensity));
tintensity=tintensity/maxs*ncolor;
figure(2)
image(tintensity);
colormap(jet(ncolor))
%xlim([50 100])
%ylim([50 100])

% Volume sliced view
intensity1=intensity(140:220,105:145,105:145);
figure(100)
h=slice(intensity1,[22],[], [20]);
set(h,'EdgeColor','none')
%alpha('color')
%alphamap('increase',.3)
colorbar 