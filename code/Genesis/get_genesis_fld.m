function intensity=get_genesis_fld(filename,ncar,nslice)
% return fld intensity from geneis dumpfld file

intensity(nslice,ncar,ncar)=0;
fid=fopen(filename,'r');
jump=ncar*ncar*16; % jump from slice to slice
for i=1:nslice
    fseek(fid, (0+(i-1)*jump), 'bof');
    same_real = fread(fid, [ncar, ncar], 'double', 8);
    fseek(fid, (8+(i-1)*jump), 'bof');
    same_imag = fread(fid, [ncar, ncar], 'double', 8);
    %field = complex(same_real, same_imag);
    intensity(i,:,:)=same_real.*same_real+same_imag.*same_imag;
end
fclose(fid);


return
