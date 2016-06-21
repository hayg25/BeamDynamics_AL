function [wake,green]=CSR_edge_wake(profil,grille,phimin,qm,nbin,step,R,L,Ls)
% calcul le wake v sur la base CSR par m de dipole
% l'applique à dp en eV
% W =0 t>0
% W =-2 / (3)**0.333 / (R)**0.666  * int( df/ds /(s-s')**0.333 ) /4 pi eps0     t<= 0
% entrance edge : (f(s-sl) - f(s-4sl))/sl**0.333
% sl=R*phi^3/24
% R    dipole radius m
% L integration length (m)
% Ls distance from bend entrance (entrance edge)
% wake


%
pieps=1.1e-10;  % 4 pi eps0


% 
df=gradient(profil)/step; 
[dprofil]=smoothing(df);

% green on bin
ds=(grille-phimin);
A=-2/pieps/power(3,1/3)/power(R,2/3);
green=power(ds,1/3);green(1)=1;
green=A./green;green(1)=0;    % remove first term

% Limite green over sl=R*phi^3/24
sl=Ls^3/24/R^2;
nn=ceil(sl/step);
if (nn+1)<nbin; green(nn+1:nbin)=0;end

% wake on bin by convolution  in volt
wake = conv(green,dprofil);
wake = wake(1:nbin);  % only the first half

% Add the component from egge entrance
f1(1:nbin)=0;
f2(1:nbin)=0;
if (  nn+1)<=nbin;  f1(nn+1:nbin)=profil(1:(nbin-nn));end
if (4*nn+1)<=nbin;f2(4*nn+1:nbin)=profil(1:(nbin-4*nn));end
edge=A*(f1-f2)/power(sl,1/3)/step;
%edge=filter(ones(1,wind)/wind,1,edge);edge=circshift(edge,[0 -(wind/2-1)]); 
% filter pertube border of edge when not=0
wake=wake+edge;
wake =wake*1e-6*qm*L;                %in MV/m

return

