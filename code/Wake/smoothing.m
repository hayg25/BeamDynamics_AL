function [profil]=smoothing(f)
% smooth f data
% moving average 
% fft filter : to be improved !
global DYNAMIC

% default filtering
filter_mode='average';
wind=4; 

if isfield(DYNAMIC,'filter_mode'); filter_mode= DYNAMIC.filter_mode ; end


% case constant moving average
if strcmp(filter_mode,'average')

    if isfield(DYNAMIC, 'wind'); wind= DYNAMIC.wind ; end
    wind= floor(wind); % odd
    %profil =filtfilt(ones(1,wind)/wind,1,f);
    
    nbin=length(f);
    A=ones(1,wind)/wind;
    f=f(nbin:-1:1);f=filter(A,1,f);
    f=f(nbin:-1:1);f=filter(A,1,f);
    profil=f;
    
 % case gaussian moving average
elseif strcmp(filter_mode,'averageg')

    if isfield(DYNAMIC, 'wind'); wind= DYNAMIC.wind ; end
    wind= floor(wind); % odd
    
    nsig=6;
    nbin=length(f);
    A=(-nsig*wind:1:nsig*wind)/wind; A=exp(-0.5*A.^2);
    A=A/sum(A);
    f=conv(A,f);
    f=f(wind*nsig+1:1:nbin+wind*nsig);
%     f=f(nbin:-1:1);f=filter(A,1,f); 
%     f=f(nbin:-1:1);f=filter(A,1,f); % gives non symetric profile ?
    profil=f; 
    
% case fft
elseif strcmp(filter_mode,'fft')
    
    if isfield(DYNAMIC, 'wind'); wind= DYNAMIC.wind ; end
    wind= floor(wind); % odd
    nbin=length(f);
    cut=floor(nbin/2-wind);
    if cut < 1; cut=1;end;
    Iw=fft(f);
    Iw(cut:nbin-cut)=0;% remove high freq up to cut (remove a lot if wind large)
    profil=real(ifft(Iw)); 
    
    
% case no average    
elseif strcmp(filter_mode,'no')
    profil=f;
end

return