function plot_disp
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot dispersion 
global LATTICE DYNAMIC
%
disp0=DYNAMIC.disp; %first
%[disp]=get_disp ;
disp=cat(2,LATTICE.disp);
dispx=[disp0(1) ; disp(1,:)'];
pos  =[0 ; cat(1,LATTICE.pos)] ;

% get lattice synopt
[synopt]=get_lattice;


figure(1)
plot(pos,dispx,'-g');hold on
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('Dx (m)')
xlim([0 pos(length(pos))])
grid on
