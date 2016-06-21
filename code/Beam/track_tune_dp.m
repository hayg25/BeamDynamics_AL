function track_tune_dp
% compute tune by tracking
% versus de/e
% No wakes
global DYNAMIC
rep ='/home/loulergue/work/matlab/code/beta_structure/';
input_file ='cls/ThomX-6/CDR_0.17_0.64_r56_0.2_sx_Dff.str';
lattice_beta2code(rep,input_file)
lattice_split(3)

np=20;
dx=1e-04; % initial x ,z for tune measure 
de=0.03; % de/e scan
nt=600;

% Initial coordinates with linear dispersion
disp= DYNAMIC.disp;
sde=2*de/np;
dd=(-de:sde:de)';
np=size(dd);np=np(1);
particles=zeros(6,np);
particles(1,:)=disp(1)*dd;particles(2,:)=disp(2)*dd;
particles(3,:)=disp(3)*dd;particles(4,:)=disp(4)*dd;
particles(6,:)=dd;

% Find closed orbite over 20 turns iterations
for i=1:np
    test0=particles(:,i);
    for n=1:20
        [test1] = track_particles(test0);
        test0=(test0+test1)/2;
    end
    particles(:,i)=test0;
end
% Add a small dx for tune analysis
particles(1,:)=particles(1,:)+dx;
particles(3,:)=particles(3,:)+dx;

% Track
X=zeros(nt,np);
Z=zeros(nt,np);
for k=1:nt
    [particles] = track_particles(particles);
    X(k,:)=complex(particles(1,:),-particles(2,:));
    Z(k,:)=complex(particles(3,:),-particles(4,:));
end

% could be vectorised
% Fourier
nux=zeros(1,np);
for n=1:np
    F = fft(X(:,n),nt)/nt*2;
    P = F.* conj(F) ;     % puissance spectrale
    [Pm,Im] = max(P(2:nt));
    nux(n)=(Im+1)/nt;
end
nuz=zeros(1,np);
for n=1:np
    F = fft(Z(:,n),nt)/nt*2;
    P = F.* conj(F) ;     % puissance spectrale
    [Pm,Im] = max(P(2:nt));
    nuz(n)=(Im+1)/nt;
end


% % Calcnaff
% nux=zeros(1,np);
% for n=1:np
%     Xm=X(:,n)-mean(X(:,n));
%     [freq amp] = calcnaff(real(Xm),imag(Xm),1,1);
%     nux(n)=freq(1)/2/pi;
% end
% nuz=zeros(1,np);
% for n=1:np
%     Zm=Z(:,n)-mean(Z(:,n));
%     [freq] = calcnaff(real(Zm),imag(Zm),1,1);
%     nuz(n)=freq(1)/2/pi;
% end

% Some plots
figure(1)
plot(dd,nux,'-or'); 
xlabel('dE/E'); ylabel('nu')
grid on
figure(2)
plot(dd,nuz,'-ob'); 
xlabel('dE/E'); ylabel('nu')
grid on

figure(3)
plot(X,'.');   
xlabel('x'); ylabel('xp')
grid on

np1=11;
csix=(nux(np1+1)-nux(np1-1))/(dd(np1+1)-dd(np1-1));
csiz=(nuz(np1+1)-nuz(np1-1))/(dd(np1+1)-dd(np1-1));

fprintf(' \n')
fprintf('Chromaticities x,z %f %f \n',csix,csiz)

return


% % could be vectorised
% % Fourier
% nux=zeros(1,np);
% for n=1:np
%     F = fft(X(:,n),nt)/nt*2;
%     P = F.* conj(F) ;     % puissance spectrale
%     [Pm,Im] = max(P(2:nt));
%     nux(n)=(Im+1)/nt;
% end
% nuz=zeros(1,np);
% for n=1:np
%     F = fft(Y(:,n),nt)/nt*2;
%     P = F.* conj(F) ;     % puissance spectrale
%     [Pm,Im] = max(P(2:nt));
%     nuz(n)=(Im+1)/nt;
% end
% 
