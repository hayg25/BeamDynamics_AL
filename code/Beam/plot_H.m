function plot_H
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot H function
global LATTICE DYNAMIC
%
lattice_split(5)
%
twiss0=DYNAMIC.twiss; %first
twiss=cat(3,LATTICE.twiss);
betax =[twiss0(1,1) ; squeeze(twiss(1,1,:))];
alphax=[twiss0(1,2) ; squeeze(twiss(1,2,:))];
gamx  =[twiss0(2,2) ; squeeze(twiss(2,2,:))];
%
disp0=DYNAMIC.disp; %first
disp=cat(2,LATTICE.disp);
dispx =[disp0(1) ; disp(1,:)'];
dispxp=[disp0(2) ; disp(2,:)'];
%
H=betax.*dispxp.*dispxp - 2*alphax.*dispx.*dispxp +  gamx.*dispx.*dispx;
pos  =[0 ; cat(1,LATTICE.pos)] ;



figure(1)
plot(pos,H,'-b');
xlabel('S (m)');ylabel('H (m.rad)')
xlim([0 pos(length(pos))])
grid on


% plot H/Volume; ~ IBS transverse effect
emtx=50e-8;
emtz=50e-8;
d=0.003;
s=0.006*sqrt(2);  % bunch length
betaz =[twiss0(3,3) ; squeeze(twiss(3,3,:))];
V=sqrt(betax*emtx+(d*dispx).^2).*sqrt(betaz*emtz)*s;
Ex=H./V;
figure(2)
plot(pos,Ex,'-b')
xlabel('S (m)');ylabel('H/Vol')
xlim([0 pos(length(pos))])
grid on

% integrated Ex over lattice
len  =[0 ; cat(1,LATTICE.length)] ;
mEx=Ex.*len;
figure(3)
plot(pos,cumsum(mEx),'-b')
xlabel('S (m)');ylabel('int(H/Vol)')
xlim([0 pos(length(pos))])
grid on
