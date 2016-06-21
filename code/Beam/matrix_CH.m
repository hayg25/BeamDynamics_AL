function [T]=matrix_CH(L,K)
% give 6*6 transfert matrix for simple RF acceleration used in linac
% K: E0(MeV) dE(MeV)  phi(deg) freq(GHz)
% 
E=K(1);Vrf=K(2);dE=Vrf*L;
phis=K(3)*pi/180;Frf=K(4)*1e9;


damp=E/(E+dE*cos(phis));
c=3e8;
kl=2*pi*Frf/c;
K=+kl*dE*sin(phis)/E;
F=L*damp*log(1+1/damp);

% From BETA damp=1 from (0/1/2) cas
T=eye(6);
T(1,2)=L;
T(3,4)=L;
T(1:4,1:4)=T(1:4,1:4)*sqrt(damp);
T(6,6)=damp;
T(6,5)=K;


return

% % from TRANSPORT
% F=L*damp*log(1+1/damp);
% T=eye(6);
% T(1,2)=F;
% T(2,2)=damp;
% T(3,4)=F;
% T(4,4)=damp;
% T(6,6)=damp;
% T(6,5)=K;
% return