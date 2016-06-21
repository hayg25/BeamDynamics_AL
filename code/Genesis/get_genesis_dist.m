function [GEN]=get_genesis_dist
% read dist file from GENESIS
% return structure GEN with the data

nslice=400;
npart=16000;
nstop =3;

if nargin == 0 ;
    rep        ='/home/loulergue/work/Genesis/';
    input_file ='distrib-test/R-Distfile-rmax2.out.par';
end
fid = fopen([rep input_file],'r');
if fid==-1
    display(['Bug file : ' rep input_file])
    return
else
    fprintf('Input file : %s \n',input_file)
end

A=fread(fid);
size(A)

return









