function plot_chro
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot chromatic focusing term

global LATTICE
%

chro=cat(3,LATTICE.chro);
chrox=squeeze(chro(1,1,:));
chroz=squeeze(chro(1,2,:));
pos  =[cat(1,LATTICE.pos)] ;

% get lattice synopt
[synopt]=get_lattice;

figure(2)
stem(pos,chrox,'-r');hold on
stem(pos,chroz,'-b');
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('chro (1/m)')
xlim([0 pos(length(pos))])
grid on

return
figure(3)
plot(pos,cumsum(chrox),'-r');hold on
plot(pos,cumsum(chroz),'-b');
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('chro (1/m)')
xlim([0 pos(length(pos))])
grid on
