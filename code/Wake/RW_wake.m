function [wake,green]=RW_wake(profil,grille,phimin,qm,nbin,step,sig,b,L)
% calcul le wake Resisitiv wall sur la base K Banes et M. Sand
% model valid pour faiscseau court aussi
% sig : conductivity  (1.4e6)
% b half beam radius or height
% L pipe lenght
% phasespace : relative coordinates
% Energy phasespace(6,:) still relative to input E
% l'applique à dp en eV
% phi distribution en position (m)
% q charge du paquet complet
% E  energy in MeV 
% L integration length (m)
% wake
% U mean losses
% 

%
c=3e8;
eps0=1/36/pi*1e-9;
%Z0=377;
s0=power(2*c*b*b*eps0/sig,1/3);


% find subdivision versus s0 for better calculations with low nbin
sub=step/s0*30;
nn=floor(sub);
if nn<1   ; nn=1   ; end;
if nn>100 ; nn=100 ; end;
ds=step/nn;

load RW_table.mat alpha tint;
% lookup table of integral (x.*x)./(power(x,6)+8).*exp(-x.*x*alpha) )
% versus alpha s/s0
% alpha in step of 0.02 from 0 to 20   : 1001 points
% tint=> 1/s ^3/2 for alpha > 20  asymptot
da=alpha(2)-alpha(1);
ntm=length(alpha);


% calcul green
pos=(grille-phimin);
green=zeros(1,length(pos));
cc=sqrt(pi)/32;
k=0;
i=0:nn-1;
ds1=ds*double(i);
for s=pos
    k=k+1;
    ss=s+ds1;
    alpha=ss/s0;
    nt=floor(alpha/da)+1;
    II=find(nt<=ntm);I=length(II);
    int=tint(nt(1:I));
    if I<nn ; int= [int cc*power(1./alpha(1,I+1:nn),1.5)]; end
    term=exp(-alpha).*cos(sqrt(3)*alpha);
    term=term/3-sqrt(2)*int/pi;
    green(k)=mean(term);
end
A=4/pi/b/b/eps0;
green=-A*green;


% wake on bin by convolution  in volt
green=green(nbin:-1:1);
wake = conv(green,profil);
wake = wake(nbin:2*nbin-1);        % only the second half
wake = wake*1e-6*L*qm;             % in MV

return




