function [dM,M0]=get_allmatrix_2nd(de)
% return nelem*6*6 chromatic second order terms dM (~approx for quad)
global  LATTICE

if nargin==0; de=1e-4 ; end
    


M01=get_matrix;
TT=eye(6);
for i=1:length(LATTICE)
   TT=squeeze(M01(i,:,:))*TT;
   M0(i,:,:)=TT;
end

% Step the QP strength
lattice_step_QP_1(de); % act over LATTICE
M11=get_matrix;
TT=eye(6);
for i=1:length(LATTICE)
   TT=squeeze(M11(i,:,:))*TT;
   M1(i,:,:)=TT;
end

% Diff
for i=1:length(LATTICE)
    dM(i,:,:)=(M0(i,:,:)-M1(i,:,:))/de;
end

% Restore QP strength
lattice_step_QP_1(-de/(1+de)); % act over LATTICE


end