function file_genesis_magin(filename,num)
% Make magin with constant taper
%   From Genesis command
%   num : nw nz aw0 da

nn=size(num);
nw =nn(1); % number of undulator
k=0;
fid = fopen([filename],'w');
fprintf(fid,'%s \n','? VERSION=1.00');
fprintf(fid,'%s \n','? AWERR= 1');
fprintf(fid,'%s \n','? UNITLENGTH= 20.0e-3');
for n=1:nw
    nz =num(n,1);   % number of period / undulator
    aw0=num(n,2);   % central strength
    da =num(n,3);   % total strength variation
    
    aw=aw0 + (-da/2:da/nz:da/2);
    
    for i=1:nz
        fprintf(fid,'%2s %10.5f  %d   %d \n','AW',aw(i),1,0);
        k=k+1;
        taw(k)=aw(i);
    end
end
%fprintf(fid,'%s \n','AW   0        20  0');

figure(1)
plot(taw,'r');
grid on

fclose(fid);

