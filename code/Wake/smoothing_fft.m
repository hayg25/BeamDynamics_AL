function [profil]=smoothing_fft(f)
% smooth f data
% moving average 
% fft filter
global DYNAMIC

n=length(f);
nf=floor(n/8);      % equivalente to 1 sigma
if nf<6; nf=6; end  % min value
Y = fft(f);
Y(nf:floor(n/2)+1)=0;
Y(floor(n/2)+1:n-nf+2)=0;
profil=real(ifft(Y));

% Pyy = Y.* conj(Y) ;
% nf=length(Y)
% figure(5);plot(log(Pyy),'-ob')



return