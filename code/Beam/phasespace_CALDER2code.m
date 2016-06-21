function [phasespace,Em,q,qm]=phasespace_CALDER2code(file,E,Npart)
% get CALDER phasespace output from Xavier
% convert unit and order
%         1       2      3       4        5         6        7
% lwfa : poids  z(1/k0) x(1/k0) y(1/k0)   pz(m_ec)  px(m_ec) py(m_ec)
% code  : x  xp  y   yp   z  de/e     ( m rad )

% E=[E0 Emin Emax dE] central energy window and small offset to get the bublle !

k0=2*pi/0.8e-6; % laser=800 nm
nc=1.7e27;  % densité * poid d'électrons = nb d'elect
mec=0.511e6;


fid = fopen(file);
% phasespace
%phasespace = fscanf(fid,'%e %e %e %e %e %e %e',[7 inf])'; %  Premier cas
%
phasespace = fscanf(fid,'%e %e %e %e %e %e %e %e',[9 inf])'; %  2ieme cas 9 col
fclose(fid);
phasespace(:,1:7)=phasespace(:,2:8);
phasespace(:,8:9)=[];
%
qp=(phasespace(:,1));
%
phasespace(:,2:4)=phasespace(:,2:4)/k0;      % Convert pos    in m
phasespace(:,5:7)=phasespace(:,5:7)*(mec);   % Convert moment in eV
phasespace(:,6)=phasespace(:,6)./phasespace(:,5);% Convert moment in mrad
phasespace(:,7)=phasespace(:,7)./phasespace(:,5);

% shuffle phasespace 
phasespace = [  phasespace(:,3) phasespace(:,6) phasespace(:,4)   ...
                phasespace(:,7) phasespace(:,2) phasespace(:,5) ];
phasespace=phasespace';
phasespace(7,:)=qp; % add charge 

%  Remove transverse particles out of energy window
E=E*1e6;
if nargin > 1;
  phasespace(6,:)=phasespace(6,:)+E(4);
  [phasespace]=acceptanceE(phasespace,6,E(2:3));
end
Em=mean(phasespace(6,:))*1e-6;
phasespace(5,:)=phasespace(5,:)-mean(phasespace(5,:));
phasespace(6,:)=phasespace(6,:)/E(1)-1;

% Charge
qp=phasespace(7,:);
q=sum(phasespace(7,:),2)*nc*1.6e-19/k0^3 ;
phasespace(7,:)=[];
qm=q/length(phasespace);

% Increase nb particles according to weight qp
nr=1;      % larger if not enought particles
rap=1/20;  % for space extension of each additional particle
disp =[ 0 ; 0 ; 0 ; 0];
[~,~,eps,~,twiss]=bunch_statistics(phasespace,0);
minq =min(qp);
tnp=floor(qp/minq)*nr;
nptot=sum(tnp);
maxnp=max(tnp);
long=[std(phasespace(5,:)) std(phasespace(6,:))];
[fill]=bunch_generation(twiss,disp,eps*rap,long*rap,maxnp,0);
test=zeros(6,nptot); % allocating
ii=1;
for i=1:length(tnp)
    np=tnp(i);
    i1=ii; i2=i1+np-1;
    test(:,i1:i2)=phasespace(:,i)*ones(1,np)+fill(:,1:np);
    ii=i2+1;
end
phasespace=test;
qm=q/length(phasespace);

% Limit particles number to Npart
if nargin==3;
    lp=length(phasespace); rp=floor(lp/Npart);
    if rp<1; rp=1; end
    phasespace=phasespace(:,1:rp:lp);% take only one over rp
    qm=qm*rp;
    q=qm*length(phasespace);
end
return



