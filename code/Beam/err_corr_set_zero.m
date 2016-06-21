function err_corr_set_zero
% set corr to zero
% Works for a line (not a ring)
global  LATTICE
nel =length(LATTICE); 
for i=1:nel
    type=LATTICE(i).type;
    if strcmp(type,'HC');LATTICE(i).strength=0;end % corr H
    if strcmp(type,'VC');LATTICE(i).strength=0;end % corr V
end

% % H planes
% for i=1:length(nhc);LATTICE(nhc(i)).strength=0;end
% 
% % V planes
% for i=1:length(nvc);LATTICE(nvc(i)).strength=0;end


