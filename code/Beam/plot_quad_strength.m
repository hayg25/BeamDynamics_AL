function plot_quad_strength
% plot quad strength
Kmax=20; 
Gmax=150; %T/m

% rep ='/home/loulergue/work/matlab/code/beta_structure/';
% input_file ='cls/ThomX-3/CDR_0.40_0.74_r56_0.2_sx.str';
% rep ='/home/loulergue/work/matlab/code/beta_structure/';
% input_file ='LUNEX5/APS-SC-V1/Linac1-chic1.str';
% 
% lattice_beta2code(rep,input_file)

[KQP  GQP]=get_quad_strength;


% plot
figure(1)
bar(GQP)
ylim([-Gmax Gmax])
ylabel('Quad gradient (T/m)');xlabel('QP number')
set(gca,'FontSize',16)
set(gca,'FontSize',14)
grid on

% plot
figure(2)
bar(KQP)
ylim([-Kmax Kmax])
ylabel('Quad strength (1/m2)');xlabel('QP number')
set(gca,'FontSize',14)
grid on
