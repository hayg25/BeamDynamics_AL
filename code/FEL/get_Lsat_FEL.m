function [Lsat,Lsat1d,Psat,Psat1d,Lg,Lg1d,Pn,P,B] = get_Lsat_FEL( Lp,Lw,eps,sige,I,beta,E0,L )
%GET_LSAT_FEL Summary of this function goes here
%  Based on Ming-Xie formulae PAC 95
%  DESIGN OPTIMIZATION FOR AN X-RAY FREE ELECTRON LASER DRIVEN BY SLAC LINAC
%  
% 7 Input parameters
% Lp : lambda photon    (m)
% Lw   lambda ondulator (m)
% eps  emittance        (m.rad) assumes H=V   /could be a vector/
% sige energy spread    (Relative)            /could be a vector/
% I    current          (A)                   /could be a vector/
% beta function         (m)  assumes H=V      /could be a vector/ or mean
% E0   beam energy      (MeV)
% L    wiggler length   (m)

% B    field            (T)
% 3 main relevant FEL parameter
% Lsat saturation length  (m)                /accordingly a vector/
% Psat saturation power   (W)                /accordingly a vector/
% Lg    Gain length                          /accordingly a vector/
% P power  over L         (W)                /accordingly a vector/

% Constant
c=3e8;
e=1.6e-19;
IA  =17.045e3; % Alfen current

% 1D model
gam =E0/0.511;   
%K   =93.4*Lw*B;aw=K/sqrt(2); % Planar undulator
%aw  =sqrt(2*Lp*gam^2/Lw);    % Planar undulator
aw  =sqrt(2*Lp.*gam.^2/Lw-1);   % Planar undulator ?
ksi =aw.^2/(1+aw.^2)/2;
B   =sqrt(2)*aw./93.4/Lw;
K   =93.4*Lw*B ; % Plana undulator
Aw  =aw.*(besselj(0,ksi) - besselj(1,ksi));

sigx=sqrt(eps.*beta);
rho =power((I./IA).*(Lw*Aw./(2*pi.*sigx)).^2,1/3)./(2*gam);
ind=find(isnan(rho));rho(ind)=1e-6; % remove NAN & force to small value
Lg  =Lw./(4*pi*sqrt(3)*rho);
Pn  =rho.^2*c.*E0*1e6/Lp*e;
Pbea=I.*E0*1e6;
Psat=rho.*Pbea;
Lsat=Lg.*log(9*Psat./Pn);
ind=find(isinf(Lsat));Lsat(ind)=Lg(ind); % remove Inf & force to Lg

% Scaled with Rayleigh, eps and sige
Lr=4*pi*sigx.^2/Lp;
etad=Lg./Lr;
etae=(Lg./beta).*(4*pi*eps./Lp);
etag=4*pi*(Lg./Lw).*(sige);

eta=0.45*power(etad,0.57)+0.55*power(etae,1.6)+3*power(etag,2) ...
   +0.35*power(etae,2.9).*power(etag,2.4)+51*power(etad,0.95).*power(etag,3) ...
   +5.4*power(etad,0.7).*power(etae,1.9) ...
   +1140*power(etad,2.2).*power(etae,2.9).*power(etag,3.2);
ind=find(isnan(eta));eta(ind)=1e+2; % remove NAN & force to large value

%  1d case
Lg1d  =Lg;
Lsat1d=Lsat;
Psat1d=Psat;

% ~3d case
Lg=Lg1d.*(1+eta);
%Psat = 1.6*rho.*Pbea./(1+eta).^2;
%Lsat =(Lg.*(1+eta)).*log(9*Psat./Pn); %negative if 9*Psat<Pn
Psat = 1.0*rho.*Pbea./(1+eta).^2;
Lsat =(Lg).*log(9*Psat./Pn);
ind=find(Lsat<0);Lsat(ind)=Lg(ind); % remove Inf & force to Lg

% Over L m of ondulator
if nargin==7; L=0   ;end
Le=min(Lsat,L);
P=Pn/9.*exp(Le./Lg);


% figure(11)
% plot(rho)

end

