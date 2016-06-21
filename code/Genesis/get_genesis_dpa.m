function get_genesis_dpa
% read *dpa file from GENESIS output : Electron Beam distribution end of ondulators


nsclice=200;
npart=8192;
E=400;
gam=E/0.511;

rep        ='/home/loulergue/work/Genesis/';
input_file ='LWFA/test-distrib-from-GEN/gen.out.dpa';
input_file1='LWFA/test-distrib-from-GEN/gen.out';


fid = fopen([rep input_file],'r');
for i=1:nsclice
    gamma(:,i) = fread(fid, npart, 'double');
    theta(:,i) = fread(fid, npart, 'double');
    x(:,i) = fread(fid, npart, 'double');
    y(:,i) = fread(fid, npart, 'double');
    px(:,i) = fread(fid, npart, 'double');
    py(:,i) = fread(fid, npart, 'double');
end

xrms=std(x);
yrms=std(y);
figure(10)
plot(xrms,'-r');hold on
plot(yrms,'-b');hold off
grid on




n=30;
% remove particles with energy -1 (lost)
 ind = find(gamma(:,n)>0);
 npart1=length(ind);
 fprintf('slice=%6.0f  npart=%6.0f  lost=%4.1f  \n',npart,npart1,(npart-npart1)/npart*100)
 
figure(1)
delta=(gamma(ind,n)-gam)/gam;
%delta=gamma(ind,n);
plot(mod(theta(ind,n),2*pi),delta*100,'.')

figure(2)
plot(x(ind,n)*1e3,y(ind,n)*1e3,'.')
% xlim([-3 3])
% ylim([-3 3])
grid on

[GEN]=get_genesis_output(rep,input_file1);
cur=GEN.cur;

figure(3)
plot(cur,'-b')
grid on

return









