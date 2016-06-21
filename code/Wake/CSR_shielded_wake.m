function [wake,green,r]=CSR_shielded_wake(profil,grille,phimin,qm,nbin,step,sigs,R,h,L)
% calcul le wake v sur la base CSR Murphy,Krinsky,Gluckstern + Debernev
% l'applique à dp en eV
% W =0 t>0
% W =-2 / (3)**0.333 / (R)**0.666  * int( df/ds /(s-s')**0.333 ) /4 pi eps0
% t<= 0
% R    dipole radius m
% E  energy in MeV 
% L integration length (m)
% h half heigth pipe
% r<0.02 no shielding  r>10 full shielding

% warning : a circshift added to prevent
% from positive main energy over the bunch
% energy gain !
% = wake_s=circshift(wake_s,[0 -1]); %added

%
pieps=1.1e-10;  % 4 pi eps0
c=3e8;
coef=sqrt(R/h)/h/2;  % convert s to x / x=coef*s
r1=0.02;
r2=10;



% compute shielding criteria
r=sigs/h*sqrt(R/h)/2;  %r<0.02 no shielding  r>10 full shielding
%fprintf('full csr 0.02 <  %5.2f < 10 full shielding \n',r);


if r>r2  % full shielding

    % No effect, all set to 0
    green=grille*0;
    wake=green;
    U=0;
    return

elseif r<r2  % CSR in free space

    dprofil=gradient(profil,step);
    [dprofil]=smoothing(dprofil);
    
    % green on bin
    ds=(grille-phimin);
    A=-2/pieps/power(3,1/3)/power(R,2/3);
    green=power(ds,1/3);green(1)=1;
    green=A./green;green(1)=0;    % remove first term

    % wake on bin by convolution  in volt
    wake = conv(green,dprofil);
    wake = wake(1:nbin);      % only the first half
    wake = wake*qm*1e-6*L;       % in MV/m
    
    if r>r1  % add shield part
        load CSR_shield.mat x G2;
        lg2=length(G2);xmin=x(1);xmax=x(lg2);
        xstep=(xmax-xmin)/(lg2-1);
        n0=(lg2+1)/2;
        nbin=nbin-1;
        green(1:2*nbin+1)=0;
        xx=[];
        n1=n0+round(-nbin*step*coef/xstep);if n1<1;n1=1;end;
        n2=round(step*coef/xstep/2) ;% demi pas
        for k=-nbin:nbin
            s=k*step; 
            x=coef*s;
            xx=[xx,x];
            n=n0+round(x/xstep); % n0 centre wake G2(n0)=0
            if n>0 && n<=lg2-n2
                green(k+nbin+1)=mean(G2(n1+n2:n+n2)); % forme int�gr� pour grand pas x
                n1=n;x1=x;
            elseif n>lg2
                green(k+nbin+1)=4/3/2.7183*(power(x,-1/3)-power(x1,-1/3))/(x-x1);
                x1=x;
            else
                green(k+nbin+1)=0;
            end
        end
        n1=nbin+1;

        % calcul wake sur bin
        A=1/h/h/2/pieps;        
        nbin=length(profil);
        profil1=profil(nbin:-1:1);  % en bug
        wake_s(1:nbin)=0;
        for i=1:1:nbin     % i=1 => avant du paquet en postion (arriere en temps=
            for j=1:nbin   % t>=0 and t<0
                %wake_s(i)=wake_s(i) + green(n1+j-i)*profil(j);
                wake_s(i)=wake_s(i) + green(n1+j-i)*profil1(j);
            end
        end
        wake_s=-A*wake_s(nbin:-1:1)*qm*1e-6*L;  % en volt
        %wake_s=circshift(wake_s,[0 -1]); %added
        %wake0=wake;
        wake=(wake-wake_s);
        [wake]=smoothing(wake);
    end

end

% figure(100)
% plot(wake0,'-b');hold on
% plot(wake_s,'-r');hold off
% figure(101)
% plot(wake,'-b')


return