function [wake,green]=BB_wake(profil,grille,phimin,qm,nbin,BB)
% calcul le wake v sur la base d'une liste broad band resonator
% BB(1,:) =Rs
% BB(2,:) =Q
% BB(3,:) =fr
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% l'applique à dp
% ws distribution liss�
% wake = wakefield on grid
% edges grille distrib wake
% U mean losses

%
nn=size(BB);
nb=nn(1);  % number of BB 
%
Rl=BB(:,1);      % Ohm
Q =BB(:,2);      % Q
fr=BB(:,3);      % frequency
wr=fr*2*pi;


% green on bin
time=(grille-phimin)/3e8;
green=0;
for i=1:nb
    A=wr(i)*Rl(i)/Q(i);
    ff=sqrt(1-1/4/Q(i)^2); 
    c1 = cos(wr(i)*ff*time);
    s1 = sin(wr(i)*ff*time)/ff/2/Q(i);
    green=green+A*exp(-wr(i)/2/Q(i)*time).*( c1-s1 );
end

% wake on bin by convolution  in volt
green=green(nbin:-1:1);
wake = conv(green,profil);
wake = wake(nbin:2*nbin-1);        % only the second half
wake = -(wake - A*profil/2)*qm;    % remove half for t=0
wake = wake*1e-6;                  %in MV

return

