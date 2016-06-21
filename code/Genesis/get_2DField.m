function Param=get_2DField(filename,ncar,nslice)

fid=fopen(filename);
Data=fread(fid,'float64');
fclose(fid);
pictname=strcat(filename,'-NearField.eps');

[Np,NpB]=size(Data)
Nz=Np/(ncar*ncar*nslice*2)
Nz=1
zz=1; i=1; j=1; 
k=1;
N2D=ncar*ncar;

for s=1:nslice
    for zz=1:Nz
        for i=1:ncar
            for j=1:ncar
                MR(i,j,s,zz)=Data(k);
                MZ(i,j,s,zz)=Data(k+N2D);
                k=k+1;
            end
        end
        k=k+N2D;
    end
end

ss=80;
zi=1;

MR_zi(:,:,:)=MR(:,:,:,zi);
MZ_zi(:,:,:)=MZ(:,:,:,zi);

MR_ss_zi(:,:)=MR(:,:,ss,zi);
MZ_ss_zi(:,:)=MZ(:,:,ss,zi);
MField_ss_zi=MR_ss_zi.^2+MZ_ss_zi.^2;

MField_zi=MR_zi.^2+MZ_zi.^2;
MField_tots_zi_2=sum(MField_zi,3);

figure(1)
%image(MField_ss_zi);
surface(MField_ss_zi);
xlabel('x (a.u.)');
ylabel('z (a.u.)');
title('Near Field output distribution at slice ss');

figure(2)
%image(MField_tots_zi);
surface(MField_tots_zi_2);
xlabel('x (a.u.)');
ylabel('z (a.u.)');
title('Projected Near Field output distribution');
saveas(gcf,pictname,'psc2');

Param.MR=MR;
Param.MZ=MZ;

return 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for s=1:300
%     for zz=1:Nz
%         for i=1:ncar
%             for j=1:ncar
%                 MR(i,j,s,zz)=Data(k);
%                 k=k+1;
%             end
%         end
%         for i=1:ncar
%             for j=1:ncar
%                 MZ(i,j,s,zz)=Data(k);
%                 k=k+1;
%             end
%         end
%     end
% end


