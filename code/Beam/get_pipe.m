function [pipex, pipez]=get_pipe
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% get pipe
global LATTICE 
%

pipe=cat(1,LATTICE.pipe);
pipex=[pipe(1,1) ; pipe(:,1)];
pipez=[pipe(1,2) ; pipe(:,2)];
return


