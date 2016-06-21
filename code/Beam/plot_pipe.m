function plot_pipe
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot pipe
global LATTICE 
%

%[disp]=get_disp ;
pipe=cat(1,LATTICE.pipe);
pipex=[pipe(1,1) ; pipe(:,1)];
pipez=[pipe(1,2) ; pipe(:,2)];
pos  =[0 ; cat(1,LATTICE.pos)] ;

% get lattice synopt
[synopt]=get_lattice;


figure(1)
set(gca,'fontsize',16)
set(gcf,'color','w')
stairs(pos,pipex*1e3,'-r','linewidth',2);hold on
stairs(pos,pipez*1e3,'-b','linewidth',2);
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
hold off;
xlabel('S (m)');ylabel('Pipe (mm)')
xlim([0 pos(length(pos))])
legend('H pipe radius','V pipe radius')
grid on
