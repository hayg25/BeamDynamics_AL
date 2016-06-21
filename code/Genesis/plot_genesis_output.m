function plot_genesis_output
%PLOT_GENESIS_OUTPUT Summary of this function goes here
%   Detailed explanation goes here

rep        ='/home/sources/physmach/loulergue/work/matlab/code/Genesis/LWFA/';
%input_file ='Cas-1mm-Chirp/R.out';
%input_file ='Cas-1mm-NoChirp/R-1mm-NoChirp.out';
%input_file ='LOA-testSM-160nm-Chirp/gen1.out';
%input_file ='LOA-testSM-160nm/gen.out';
%input_file ='LOA-testSM-100nm/gen.out';
%input_file ='LOA-testSM-40nm/gen.out';
%input_file ='LOA-testSM-40nm-Chirp/gen.out';
%input_file ='LOA-testSM-10nm/gen.out';
%input_file ='LOA-testSM-40nm-Chirp-seeded/gen.out';
%input_file ='COX-200nm-Chirp-SASE-saved/gen.out';
input_file ='COX-200nm-Chirp-SEED/gen.out';
%input_file ='COX-200nm-Chirp-SEED-times/gen.out';
%input_file ='COX-200nm-Chirp-SASE/gen.out';
%input_file ='COX-40nm-Chirp-SEED-saved/gen.out';
%input_file ='COX-40nm-Chirp-SEED/gen.out';
%input_file ='COX-03nm-Chirp-SEED/gen.out';
%input_file ='LOA-testSM-160nm/test10-NoChirp.out';
%input_file ='LOA-testSM-160nm/CL1mm-NoChirp.out';
%input_file ='test/R.out';
%input_file ='Cas-0mm/gen.out';
%input_file ='LOA-testSM-40nm-Chirp/gen.out';
%input_file ='LOA-testSmooth-40nm/gen.out';
%input_file ='LOA-testSM-26nm-helical/gen.out';
%input_file ='LOA-testSM-200nm/gen.out';
%%

[GEN]=get_genesis_output(rep,input_file);

nslice=GEN.slice(1);
dslice=GEN.slice(2);
zslice=[1:nslice]*dslice;
nstep=GEN.nstep;
cur=GEN.cur;
zstep=GEN.Z(1,:);
Slabel=GEN.Slabel;
lambda0=GEN.wavelenght;
fprintf('Nslice %g  Dslice %g \n',nslice,dslice)


% Peak power profil at end
figure(1)
plot(zslice*1e6,GEN.S(:,1,nstep))
xlabel('s bunch (µm)')
ylabel(Slabel{1})
set(gca,'Fontsize',16)
grid on

% cur profil
figure(2)
%plot(zslice*1e6,cur)
plot(zslice*1e6,cur)
xlabel('s bunch (µm)')
ylabel('A')
set(gca,'Fontsize',16)
grid on

% Peak power along z
[Pm,ns]=max(GEN.S(:,1,:));
Pm=squeeze(Pm);
figure(3)
semilogy(zstep,Pm); hold off
xlabel('s und (m)')
ylabel(Slabel{1})
title('Peak power along undulator')
set(gca,'Fontsize',16)
grid on
ylim([0 max(Pm)*5])

% 2D power profile
% slice normalisation along s und
P2 =squeeze(GEN.S(:,1,:));
[maxs,indm]=(max(P2));
Norm=ones(nslice,1)*maxs;
P2n=P2./Norm*64; 
figure(4)
image(zslice*1e6,zstep,P2n')
xlabel('s bunch (µm)')
ylabel('s und (m)')
set(gca,'Fontsize',16)
title('Power density')
axis xy

ix=find(strcmp(Slabel,'xrms'));
if (exist(ix)==0),return,end
iy=find(strcmp(Slabel,'yrms'));
if (exist(iy)==0),return,end
% 2D density profile
% slice normalisation along s und
P=squeeze(GEN.S(:,ix,:));PX=1./P;PX(isinf(PX))=0;
P=squeeze(GEN.S(:,iy,:));PY=1./P;PY(isinf(PY))=0;
P2=PX.*PY;
mc=max(cur);
cur(find(cur<mc/50))=0;% to remove some border spikes
tcur=ones(nstep,1)*cur;
P2=P2.*tcur';
Norm=max((max(P2)));
P2n=P2/Norm*64; 
figure(41)
image(zslice*1e6,zstep,P2n'); hold on
plot(dslice*1e6*indm,zstep,'-w','linewidth',2); hold off
xlabel('s bunch (µm)')
ylabel('s und (m)')
set(gca,'Fontsize',16)
title(['Beam density     max= ',num2str(floor(Norm*1e-9)),' kA/mm2'])
axis xy

% Central slice env along z (slice Not very accurate)
%[curm cm]=max(cur);
cm=round(sum(cur.*[1:nslice])/sum(cur));  % mean position based on current
xm=squeeze(GEN.S(cm,ix,:));
zm=squeeze(GEN.S(cm,iy,:));
figure(34)
plot(zstep,xm,'-r');hold on
plot(zstep,zm,'-b');hold off
xlabel('s und (m)')
%ylabel(Slabel{8})
set(gca,'Fontsize',14)
grid on


% Beam size according to max slice power
ns=squeeze(ns);
for i=1:length(ns)
    xrms_pmax(i)=GEN.S(ns(i),ix,i);
    zrms_pmax(i)=GEN.S(ns(i),iy,i);
end
figure(5)
plot(zstep,xrms_pmax,'-r');hold on
plot(zstep,zrms_pmax,'-b');hold off
xlabel('s Und (m)')
ylabel(Slabel{ix})
title('Beam size according to max slice power')
set(gca,'Fontsize',16)
grid on
%return

% FEL size according to max slice power
ir=find(strcmp(Slabel,'r_size'));
ia=find(strcmp(Slabel,'angle'));
ns=squeeze(ns);
for i=1:length(ns)
    rrms_pmax(i)=GEN.S(ns(i),ir,i);
    arms_pmax(i)=GEN.S(ns(i),ia,i);
end
figure(51)
plot(zstep,rrms_pmax,'-r');hold on
plot(zstep,arms_pmax,'-b');hold off
xlabel('s und (m)')
ylabel(Slabel{ir})
legend('Radial','Divergence')
title('FEL size according to max slice power')
set(gca,'Fontsize',16)
grid on


% na=[-10 : 10]+ns(100);
% figure(47)
% plot(na,GEN.S(na,ia,100))
% figure(48)
% plot(na,GEN.S(na,1,100))
% figure(49)
% plot(na,GEN.S(na,ir,100))

%return
%Wavelength : 
paxe =GEN.S(:,3,nstep);
phaxe=GEN.S(:,4,nstep);
pp=sqrt(paxe).*exp(-1i*phaxe);
N = 2^nextpow2(nslice);
Y = fft(pp,N)/nslice;
n =fix(N/2)+1;
Y=power(circshift(abs(Y),-n),2);
lambda=(linspace(0,1,N)-0.5)*lambda0+lambda0;
figure(6)
plot(lambda*1e9,Y)
xlabel('Lambda (nm)')
%xlim([0 2*lambda0]*1e9)
ylabel('u.a.')
set(gca,'Fontsize',16)
grid on

