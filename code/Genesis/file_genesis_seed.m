function file_genesis_seed(filename,num)
% Make seed with Gaussian profile + times shift
%   From Genesis command
%   num : nslice lambda rms [m] Pmax [W] ds [m] ZRAYL ZWAIST
%   

nw =num(1); % number of step
dZ =num(2);
sigz=num(3);
Pmax=num(4);
Z0 =num(5);
ZRAYL=num(6);
ZWAIST=num(7);

fid = fopen([filename],'w');
fprintf(fid,'%s \n','? VERSION=1.00');
fprintf(fid,'%s %i \n','? SIZE= ',nw);
fprintf(fid,'%s \n','? COLUMNS ZPOS PRAD0 ZRAYL ZWAIST');
for n=1:nw
    Z=n*dZ;
    P=Pmax*exp(-(Z-Z0)^2/sigz^2/2);
    fprintf(fid,'%d  %d  %d  %d \n',Z,P,ZRAYL,ZWAIST);
    
end


fclose(fid);

