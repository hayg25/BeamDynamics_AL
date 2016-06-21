function plot_r56
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot twiss parameter
global  LATTICE 
%

M=eye(6);r56=[0];
matrix=cat(3,LATTICE.matrix);
for i=1:length(matrix)
    M=matrix(:,:,i)*M;
    r56  =[r56 squeeze(M(5,6))];
end

pos  =[0 ; cat(1,LATTICE.pos)] ;

figure(1)
plot(pos,r56,'-k')
xlabel('S (m)');ylabel('r56 (m)')
xlim([0 pos(length(pos))])
grid on

