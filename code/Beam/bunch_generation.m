function [phasespace,qm]=bunch_generation(twiss,disp,eps,long,np,q,sigm)
% Give 6 dim phasespace with gaussian electron distribution
% twiss = 4 transverse twiss param
% disp  = 4 vector dispersion
% eps   = 2 transverse geometric emittances
% long  = length im meter, E-sread relative
% np    = number of particules
% E     = energie in MeV
% sigm  = max sigma for random


if nargin==0  % default data
    np  =1000;
    long=[0.001 0.001 0];
    eps =[1 1]*1e-6;
    twiss=[1 0 1 0];
    disp =[ 0 ; 0 ; 0 ; 0];
end

%
bx=twiss(1);ax=twiss(2);epsx=eps(1);
by=twiss(3);ay=twiss(4);epsy=eps(2);
sigs=long(1);
sigp=long(2);
if length(long)==3
    corr=long(3);
else
    corr=0;
end

% Generate upright ellipse
phasespace= randn(6,np); 
%phasespace(5,:)=(2*rand(1,np)-1)*sqrt(3); %for flat top
%phasespace(1,:)=(2*rand(1,np)-1)*sqrt(3); %for flat top
phasespace(6,:)=(2*rand(1,np)-1)*sqrt(3); %for flat top

% remove particles out of sigm
if nargin==7
    ind = find(abs(phasespace(6,:))<sigm);
    phasespace=phasespace(:,ind) ;
    ind = find(abs(phasespace(5,:))<sigm);
    phasespace=phasespace(:,ind) ;
    ind = find(abs(phasespace(4,:))<sigm);
    phasespace=phasespace(:,ind) ;
    ind = find(abs(phasespace(3,:))<sigm);
    phasespace=phasespace(:,ind) ;
    ind = find(abs(phasespace(2,:))<sigm);
    phasespace=phasespace(:,ind) ;
    ind = find(abs(phasespace(1,:))<sigm);
    phasespace=phasespace(:,ind) ;
end

% set charge per macro
qm=q/length(phasespace(1,:));

% set the first 11 particles for traking
% regular s position from -sig to sig  with 0 elsewhere
% if nargin==6;sigm=3;end
% k=1:11;
% ds=2*sigm/(10);ss=-sigm:ds:sigm;
% phasespace(:,k)=0;
% phasespace(5,k)=ss;



%Remove mean value to center
for i=1:6
    phasespace(i,:)=phasespace(i,:) - mean(phasespace(i,:));
end


% Apply size
phasespace(1:2,:)=sqrt(epsx)*phasespace(1:2,:);% H
phasespace(3:4,:)=sqrt(epsy)*phasespace(3:4,:);% V
phasespace(5,:)=sigs*phasespace(5,:);   % lenght
phasespace(6,:)=sigp*phasespace(6,:);   % spread

% Fit transverse twiss from (1, 0) to (b a) with phi=0
T=[sqrt(bx) 0 ; ax/sqrt(bx)  1/sqrt(bx)];
phasespace(1:2,:)=T*phasespace(1:2,:);
T=[sqrt(by) 0 ; ay/sqrt(by)  1/sqrt(by)];
phasespace(3:4,:)=T*phasespace(3:4,:);

% diff btween px/p0 and px/pz
% xp=phasespace(2,:);
% zp=phasespace(4,:);
% d =phasespace(6,:);
% dd  =sqrt((1+d).^2-xp.^2-zp.^2);
% phasespace(2,:)=phasespace(2,:).*dd;
% phasespace(4,:)=phasespace(4,:).*dd;


% Generate energy position correlation
phasespace(6,:)=phasespace(6,:)+corr*phasespace(5,:);


% Generate dispersion correlation for x,xp z zp
% x=x+Dx
phasespace(1:4,:)=phasespace(1:4,:) + disp(1:4)*phasespace(6,:);



return