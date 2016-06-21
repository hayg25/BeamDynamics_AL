function plot_envS
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot bunch length 
global LATTICE DYNAMIC
%
twiss0=DYNAMIC.twiss; %first
betax =twiss0(1,1) ; 
alphax=twiss0(1,2) ; 
gamx  =twiss0(2,2) ; 
emt   =DYNAMIC.emittance;
emtx  =emt(1);
%
matrix=cat(3,LATTICE.matrix);
r51  =squeeze(matrix(5,1,:));
r52  =squeeze(matrix(5,2,:));

%
sigs2=betax.*r51.^2 - 2*alphax.*r51.*r52 +  gamx.*r52.^2;
sigs=emtx*sqrt(sigs2);
pos  =[cat(1,LATTICE.pos)] ;


figure(1)
plot(pos,sigs,'-b');
xlabel('S (m)');ylabel('Sigs (m)')
xlim([0 pos(length(pos))])
grid on

