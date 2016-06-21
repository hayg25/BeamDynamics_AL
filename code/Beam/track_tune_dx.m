function track_tune_dx
% compute tune by tracking
% versus dx
% No wakes
global  LATTICE 

lattice_split(1)

np=20;
dx=0.008; % scan
dz=0.018; % scan
nt=600;  % multiple de 6 for calcnaff

sdx=dx/np;
ddx=(sdx:sdx:dx)';
sdz=dz/np;
ddz=(sdz:sdz:dz)';
np=size(ddx);np=np(1);
particles=zeros(6,2*np);
particles(1,(   1:  np))=ddx;  % en x first series
particles(3,(np+1:2*np))=ddz;  % en z second series


% track
nelem=length(LATTICE);
X=zeros(nt,np);
Z=zeros(nt,np);
for k=1:nt
    % Track from 1 to nelem
    for i=1:nelem
        type=LATTICE(i).type;
        T   =LATTICE(i).matrix;
        L   =LATTICE(i).length;
        K   =LATTICE(i).strength;
        ksi =LATTICE(i).chro;
        %
        if     strcmp(type,'RF')
            %skip
        elseif strcmp(type,'SX')
            [particles]=SX_pass(particles,K*L); 
        elseif strcmp(type,'QFF')
            [particles]=QFF_pass(particles,K);
        elseif strcmp(type,'DI')
            % Case exact integration
            [particles]=dipole_pass(particles,L,K);
        else
            particles=T*particles;
            [particles]=Chro_pass(particles,ksi);
        end
        %
    end   
    X(k,:)=complex(particles(1,(1:np)),-particles(2,(1:np)));
    Z(k,:)=complex(particles(3,(np+1:2*np)),-particles(4,(np+1:2*np)));
end

% Calcnaff
nux=zeros(1,np);
for n=1:np
    Xm=X(:,n)-mean(X(:,n));
    [freq amp] = calcnaff(real(Xm),imag(Xm),1,1);
    nux(n)=freq(1)/2/pi;
end
nuz=zeros(1,np);
for n=1:np
    Zm=Z(:,n)-mean(Z(:,n));
    [freq] = calcnaff(real(Zm),imag(Zm),1,1);
    nuz(n)=freq(1)/2/pi;
end


figure(1)
plot(X,'.');   
xlabel('x'); ylabel('xp')
grid on

figure(2)
plot(Z,'.'); 
xlabel('z'); ylabel('zp')
grid on

figure(3)
plot(ddx,nux,'-or'); hold on  
plot(ddz,nuz,'-ob'); hold off 
xlabel('X,Z'); ylabel('nu')
legend('X','Z')
grid on

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
%     F = fft(Z(:,n),nt)/nt*2;
%     P = F.* conj(F) ;     % puissance spectrale
%     [Pm,Im] = max(P(2:nt));
%     nuz(n)=(Im+1)/nt;
% end

