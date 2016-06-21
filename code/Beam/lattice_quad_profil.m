function lattice_quad_profil(elem_name,QP,ds)
%  split quad according to a field profil  (div)
%  From half Field 0 to positive direction (forward)
%  shorten adjacent drift to accomodta extra length
%  LATTICE size increase according to number of subdivision
%  G(:,1) s abcisse subdivision centred
%  G(:,2) field profile normalized : int G =1
%  div :number of division

% 
global  ELEMENT LATTICE DYNAMIC
%
% Get QP profile
S=QP.S;G=QP.G;
Smax=S(length(S));Smin=-Smax;
step=S(2)-S(1);
S1=S;G1=S;
%
if nargin==3   % Interpolate according to ds
    step=ds;
    S1=(0:step:Smax);
    G1=interp1(S,G,S1);
end
div=length(G1);
Smax=S1(div)+step/2;
Smin=-Smax;

% Find concerned element and modify length and pos
% Modify side drifts length to keep total length
% Modify side drifts matrices
nelem=length(LATTICE);
nelt=[];
for i=1:nelem
    nom =LATTICE(i).name;
    if strcmp(nom,elem_name)
        nelt=[nelt i];  
        L1=LATTICE(i-1).length;P1=LATTICE(i-1).pos;
        L2=LATTICE(i).length;  P2=LATTICE(i).pos;
        K2=LATTICE(i).strength;KL2=K2*L2;
        L3=LATTICE(i+1).length;P3=LATTICE(i+1).pos;
        %
        A1=(L2/2+Smin);A2=-(L2/2-Smax);
        %
        LATTICE(i-1).length=L1+A1;
        LATTICE(i-1).pos   =P1+A1;
        LATTICE(i-1).matrix=matrix_drift(L1+A1);
        LATTICE(i).length  =L2-A1+A2;
        LATTICE(i).pos     =P2+A2;
        LATTICE(i+1).length=L3-A2;
        LATTICE(i+1).pos   =P3;
        LATTICE(i+1).matrix=matrix_drift(L3-A2);
        %
        if (LATTICE(i-1).length<=0);fprintf('==> Negative length \n');end
        if (LATTICE(i+1).length<=0);fprintf('==> Negative length \n');end
    end
end

% Normalized integrated gradient to be equivalent
% Over half
G1=G1./((2*sum(G1)-G1(1))*step)*KL2*1; 

% Split concerned element 
% and set strength profile
LATTICE0=LATTICE;

if div>1                        % split element
    j=0;
    for i=1:nelem               % run over LATTICE0
        j=j+1;
        LATTICE(j)=LATTICE0(i);
        nom =LATTICE0(i).name;   
        if strcmp(nom,elem_name)
            pos0=LATTICE0(i-1).pos;
            
            for k=1:(2*div-1) 
                % to complete for negative part
                if (k<div); K1(k)=G1(div-k+1);end
                if (k>=div);  K1(k)=G1(k-div+1);end
                SS1(k)=pos0+step*k;
                
                num=LATTICE0(i).num;
                LATTICE(j)=LATTICE0(i);
                ELEMENT(num).div=div;
                LATTICE(j).div=[div k];   %j-iem element
                LATTICE(j).strength=K1(k);
                LATTICE(j).length=step;
                LATTICE(j).pos=pos0+step*k;
                LATTICE(j).matrix=matrix_quad(step,K1(k));
                j=j+1;
                
            end
            j=j-1;
        end
    end
    LATTICE=LATTICE';
end

% Complet the LATTICE structure
twiss0=DYNAMIC.twiss;%input
disp0=DYNAMIC.disp ;%input
M=eye(6);
for i=1:length(LATTICE)
    T     =LATTICE(i).matrix;
    M=T*M;
    LATTICE(i).twiss=M*twiss0*M';
    LATTICE(i).disp=M*disp0;
end
DYNAMIC.matrix=M;

%% plot
S0=[0  L1  L1   L1+L2  L1+L2   L1+L2+L3];
G0=[0  0   K2   K2   0    0];
figure(1)
set(gcf,'color','w')
set(gca,'FontSize',16)
plot(S0*1000,G0,'-k','linewidth',2);hold on
plot((SS1-pos0+(L1+A1))*1000,K1,'-b','linewidth',2)
stairs((SS1-pos0-step+L1+A1)*1000,K1,'-b');hold off
xlabel('S (mm) ');ylabel('K (m^{-2})');
grid on
%axis tight

return
