function [dM,M0]=get_matrix_2nd(de)
% return 6*6 chromatic second order terms dM (~approx for quad)
global  DYNAMIC 

if nargin==0; de=1e-4 ; end
    
M0=DYNAMIC.matrix;

% step the QP strength
%lattice_step_QP(de);  % act over ELEMENT
lattice_step_QP_1(de); % act over LATTICE
M1=DYNAMIC.matrix;
dM=(M0-M1)/de;

% Restore QP strength
%lattice_step_QP(-de/(1+de));  % act over ELEMENT
lattice_step_QP_1(-de/(1+de)); % act over LATTICE


end