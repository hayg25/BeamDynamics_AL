function [GEN]=get_genesis_output(rep,input_file)
% read big output file from GENESIS
% return structure GEN with the data

%GEN.slice=[nslice dslice];
%GEN.nstep=[nstep];    along z
%GEN.Z=Z;              zstep aw0  ...
%GEN.Zlabel=Zlabel';
%GEN.S=S;              nslice  param  zstep  big file
%GEN.Slabel=Slabel';


if nargin == 0 ;
    rep        ='/home/loulergue/work/Genesis/LWFA/';
    input_file ='Cas-1mm-NoChirp/R-1mm-NoChirp.out';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lecture input file
fid = fopen([rep input_file],'r');
if fid==-1
    display(['Bug file : ' rep input_file])
    return
else
    fprintf('Input file : %s \n',input_file)
end

txt_flag1='flags for output parameter';test1=0;
while (~feof(fid)) 
    C = textscan(fid,'%s',1,'delimiter','\n');
    test1=strcmp(C{1},txt_flag1);
    if (test1)
        % Get arrangement data
        C = textscan(fid,'%s',1,'delimiter','\n');
        C = textscan(fid,'%s',1,'delimiter','\n');
        list=textscan( char(C{1}),'%s');
        nstep=str2double(list{1}(1));
        C = textscan(fid,'%s',1,'delimiter','\n');
        list=textscan( char(C{1}),'%s');
        nslice=str2double(list{1}(1));
        C = textscan(fid,'%s',1,'delimiter','\n');
        list=textscan( char(C{1}),'%s');
        wavelength=str2double(list{1}(1));
        C = textscan(fid,'%s',1,'delimiter','\n');        
        list=textscan( char(C{1}),'%s');
        dslice=str2double(list{1}(1));
        
        % Get Z data
        C=textscan(fid,'%s',8,'delimiter','\n');
        list=textscan( char(C{1}(8)),'%s');
        Zlabel=list{1};
        Z= fscanf(fid, '%g %g %g', [3 nstep]);
        C = textscan(fid,'%s',2,'delimiter','\n'); 
  
        % Get Slice data
        % S(nslice,nstep,c)=[];
        for i=1:nslice
            C = textscan(fid,'%s',6,'delimiter','\n');
            list=textscan( char(C{1}(6)),'%s');
            Slabel=list{1};c=length(Slabel);
            A=fscanf(fid, '%g', [c nstep]);
            if size(A)==[c nstep]
                list=textscan( char(C{1}(3)),'%s');
                cur(i)=str2double(list{1}(1));
                S(i,1:c,1:nstep)= A;
                B=textscan(fid,'%s',2,'delimiter','\n');
            else
                nslice=i-1;
                break
            end
        end
        break
    end
end
fclose(fid);

GEN.wavelenght=wavelength;
GEN.slice=[nslice dslice];
GEN.nstep=[nstep];
GEN.cur=cur;
GEN.Z=Z;
GEN.Zlabel=Zlabel';
GEN.S=S;
GEN.Slabel=Slabel';


return









