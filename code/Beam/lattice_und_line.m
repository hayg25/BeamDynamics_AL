function lattice_und_line
%  Match fodo line over undulators and quad
global ELEMENT LATTICE0 LATTICE DYNAMIC
ELEMENT=[];LATTICE0=[];LATTICE=[];DYNAMIC=[];

E=400; gam =E/0.511; Brho=0.333*E/100;
Lp=20e-9;  Lw=20e-3; L=3.; nund=5;
l=0.20;
ql=0.1;
dl=(l-ql)/2;

% Make the matrix over one period & matched optics
% Half Plana undulator
aw=sqrt(2*Lp*gam^2/Lw);    
B =sqrt(2)*aw/93.4/Lw;  
rho=Brho/B;
TU=matrix_ID(L/2,rho);
% Half Quadrupole
K=L/sqrt(2)/rho/(ql*4); % 1/4 the und foc strength per quad
TQ=matrix_quad(ql/2,K,E);
% Drift
TD=matrix_drift(dl);
% Matrix product from half quad
T1=TQ*TD*TU*TU*TD*TQ;
[Tx1,Tz1,nu,flag]=get_transverse_matching(T1);
% Matrix product from half und
T2=TU*TD*TQ*TQ*TD*TU;
[Tx2,Tz2,nu,flag]=get_transverse_matching(T2);

bxm=(Tx1(1,1)+Tx2(1,1))/2;
bzm=(Tz1(1,1)+Tz2(1,1))/2;
bxzm=sqrt(bxm*bzm);
fprintf('######## Undulator line ########### \n')
fprintf(' E  = %6.2f MeV   Lambda = %6.2f nm  Lw = %6.2f mm  B = %6.2d T \n' ...
          ,E,Lp*1e9,Lw*1e3,B) 
fprintf(' bx = %8.2d  %8.2d   mean= %8.2d \n',Tx1(1,1),Tx2(1,1), bxm )
fprintf(' bz = %8.2d  %8.2d   mean= %8.2d \n',Tz1(1,1),Tz2(1,1), bzm )
fprintf(' bxzmean =%8.2d \n',bxzm) 

% Make  ELEMENT LATTICE0 
%Drift
ELEMENT(1).name    ='SDU';
ELEMENT(1).type    ='SD';
ELEMENT(1).length  =dl;
ELEMENT(1).div     =1;
%Half QUAD
ELEMENT(2).name    ='QPU';
ELEMENT(2).type    ='QP';
ELEMENT(2).length  =ql/2;
ELEMENT(2).div     =1;
ELEMENT(2).strength=K;
%Half UNDULATOR
ELEMENT(3).name    ='UND';
ELEMENT(3).type    ='ID';
ELEMENT(3).length  =L/2;
ELEMENT(3).div     =1;
ELEMENT(3).strength=rho;

% LATTICE
num=[2 1 3 3 1 2];% 1 period 
for i=1:length(num) 
    k=num(i);
    LATTICE(i).name=ELEMENT(k).name;
    LATTICE(i).num=k;
    LATTICE(i).type=ELEMENT(k).type;
    LATTICE(i).length=ELEMENT(k).length;
    LATTICE(i).div=[1 1];
    LATTICE(i).strength=ELEMENT(k).strength;
end

% DYNAMIC
DYNAMIC.file='und_line';
DYNAMIC.energy=E;
DYNAMIC.restmass=0.511;
DYNAMIC.period=nund;
DYNAMIC.emittance=[0 0 0]';
beta=zeros(6);beta(1:2,1:2)=Tx1;beta(3:4,3:4)=Tz1;
DYNAMIC.twiss=beta;
DYNAMIC.disp=[0 0 0 0 0 1]';
%
lattice_fill;
LATTICE0=LATTICE;  % save base for future splitting

plot_optic
end

