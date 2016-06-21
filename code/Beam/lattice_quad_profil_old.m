function lattice_quad_profil_old
%  split quad according to a field profil  (div)
%  add negative dritf if longer than hard edge
%  LATTICE size increase according to number of subdivision
%  G(:,1) s abcisse subdivision centred
%  G(:,2) field profile normalized : int G =1
%  div :number of division

% To be finished ...

% 
global DYNAMIC ELEMENT LATTICE0 LATTICE
%
rep ='../beta_structure/';
%input_file ='cls/ThomX-1/LT_4dip_nochicane_emit1.str';
input_file ='cls/ThomX-3/CDR_0.40_0.74_r56_0.2_sx_DLff2.str';
lattice_beta2code(rep,input_file)


% Get Qpole S profil from RADIA : every 1 mm from 0 to 300 mm
len=0.150; % Qpole bore length
A=load('../data/Mag_Field/Bprofil-s-ThomX-Qpole.dat');
S=A(:,1);
G=A(:,2);
% reduce to every 5 mm
S1=(0:5:300);
G1=interp1(S,G,S1);
norm=sum(G1);G1=G1/norm;
div=length(G1)
len1=S1(div)*1e-3
lff=(len1-len)/2 % to be removed
%plot(S1,G1,'-or');hold off


% add negdrift apart of each quad
% negative step back to restore length
element_add_2drift(-lff);

nelem=length(LATTICE0);
% restore basic LATTICE to LATTIC0
LATTICE=LATTICE0;
for i=1:length(ELEMENT)
    ELEMENT(i).div=1;
end
if div>1                        % split element
    j=0;
    for i=1:nelem               % run over LATTICE0
        j=j+1;
        LATTICE(j)=LATTICE0(i);
        T=LATTICE(j).type;   
        if  strcmp(T,'QP')          % split egal element by div and increment LATTICE
            num=LATTICE0(i).num;
            ELEMENT(num).div=div;
            ELEMENT(num).length=len1;
            LATTICE(j).div=[div 1]; % first element
            for k=1:(div-1)
                j=j+1;
                LATTICE(j)=LATTICE0(i);
                LATTICE(j).div=[div (k+1)];   %j-iem element
            end    
        end
    end
    LATTICE=LATTICE';
end
%
% New structure LATTICE
lattice_fill;

% Implement the quad strength profil
nelem=length(LATTICE);
for i=1:nelem               % run over LATTICE
    T=LATTICE(i).type;
    if  strcmp(T,'QP')  
     str=LATTICE(i).strength; 
     ll=LATTICE(i).length;
     div=LATTICE(i).div;
     K=str*G1(div(2))*div(1)*len/len1;
      if K>0 ; K=K*1.012 ;end
      if K<0 ; K=K*1.0145;end
     LATTICE(i).matrix=matrix_quad(ll,K);
    end
end

% Implement the twiss function
M=eye(6);
for i=1:nelem
    T     =LATTICE(i).matrix;
    M=T*M;
end
[nu]=get_tune(M)
twiss0=eye(6)*0;
twiss0(1,1)=M(1,2)/sin(2*pi*nu(1));
twiss0(1,2)=0.5*(M(1,1)-M(2,2))/sin(2*pi*nu(1));
twiss0(2,1)=twiss0(1,2);
twiss0(2,2)=-M(2,1)/sin(2*pi*nu(1));
%
twiss0(3,3)=M(3,4)/sin(2*pi*nu(2));
twiss0(3,4)=0.5*(M(1,1)-M(2,2))/sin(2*pi*nu(2));
twiss0(4,3)=twiss0(3,4);
twiss0(4,4)=-M(4,3)/sin(2*pi*nu(2));


%twiss0=DYNAMIC.twiss %input
disp0=DYNAMIC.disp ;%input
M=eye(6);
for i=1:nelem
    T     =LATTICE(i).matrix;
    M=T*M;
    LATTICE(i).twiss=M*twiss0*M';
    LATTICE(i).disp=M*disp0;
end


% Plot
ll=cat(1,LATTICE.length);
tab=find(ll > 0); % to remove negative dritf in plot

twiss0=DYNAMIC.twiss; %first
twiss=cat(3,LATTICE.twiss);
bx=squeeze(twiss(1,1,:));
bz=squeeze(twiss(3,3,:));
betax=[twiss0(1,1) ; bx(tab)];
betaz=[twiss0(3,3) ; bz(tab)];
p=cat(1,LATTICE.pos);
pos  =[0 ; p(tab)] ;
pos_end=pos(length(pos));
% get lattice synopt
[synopt]=get_lattice;


figure(1)
plot(pos,betax,'-r');hold on;
plot(pos,betaz,'-b');
%plot(pos,dispx*10,'-g');
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('Beta, Disp (m)')
legend('Betax','Betaz','D*10')
set(gca,'FontSize',16)
xlim([0 pos_end]/2)
grid on



return
