function lattice_beta2code(rep,input_file,pr)
% Get beta file "name"
% Make matlab structure :
%    ELEMENT.   for list of element type
%               struct array with fields:
%                      name
%                      type
%                      split    number of split (default=1, no split)
%                      length
%                      strength  normalised to brho, (rho for dipole)
%                                            (tan(teta)/rho for dipole edge)

%    LATTICE0.  element list by order in the lattice, base no pslit
%               struct array with fields:
%                     .name
%                     .nume     targetting ELEMENT.
%                     .pos      out position in m
%                     .length   element length
%                     .div      [ndiv  n]
%                     .matrix   6*6 transfert matrix
%                     .twiss    6*6 twiss matrix
%                     .disp     6 disp vector

%    LATTICE.  idem wilth higher number of element depending on split

%    DYNAMIC.  global data
%                .file
%                .energy  
%                .restmass
%                .beta      input data matrix (bx ax gx bz az gz) 6*6
%                .disp      input data vector (dx  dxp dz   dzp  0    0) 6
%                .emittance input data vector (epx epx epsz epz eps eps) 6
%
global ELEMENT LATTICE0 LATTICE DYNAMIC
ELEMENT=[];LATTICE0=[];LATTICE=[];DYNAMIC=[];

if (nargin<3);fprintf('##########################\n');end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lecture input file
fid = fopen([rep input_file],'r');
if fid==-1
    display(['Bug file : ' rep input_file])
    return
else
    if (nargin<3);fprintf('Input file %s \n',input_file);end
end
nline=0;
% stock lines in txt
while (~feof(fid)) 
    C = textscan(fid,'%s',1,'delimiter','\n');
    nline=nline+1;
    txt(nline)=C;
end
fclose(fid);
nline=nline-1;

% Get blocks
block_type={'*** VERSION ***', '*** AUTHOR ***','*** TITRE ***',...
            '*** LIST OF ELEMENTS ***','*** STRUCTURE ***','*** PERIOD ***',...
            '*** OPTION ***','*** BEAM-MATRIX ***','*** DISPERSION ***',...
            '*** PARTICLE TYPE ***','*** ENERGIE CINETIQUE (MeV) ***',...
            '*** EMITTANCE ***','*** PARAMETERS OF FIT ***','*** VARIABLES ***',...
            '*** CONSTRAINTS ***','*** ENDFILE ***'};
nblock=length(block_type);
for i=1:nline
    for j=1:nblock
       test=strcmp(txt{i},block_type(j));
       if test
          block_line(j)=i;
          %fprintf('block %32s      at line %d  \n',block_type{j},block_line(j))
       end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get element family 
% in block *** LIST OF ELEMENTS ***, n=4
%
element_type={'SD','QP','SX','DI','CO','BH','CH','ID','HC','VC','HP','VP','SF','OB'};
ntype=length(element_type);
nl1=block_line(4)+2;
nl2=block_line(5)-1;
family=eye(ntype,1)*0;
nelem=0;
for i=nl1:nl2
    ligne=txt{i};
    list=strread(char(ligne),'%s');
    if (length(list)>1)
        for j=1:ntype
            type=element_type{j};
            if strcmp(list{2},type) ;
                nelem=nelem+1;
                family(j)=family(j)+1;
                ELEMENT(nelem).name=list{1};
                ELEMENT(nelem).type=list{2};
                %ELEMENT(nelem).length=str2num(list{3});
                ELEMENT(nelem).div   =1;                          
                if strcmp(list{2},'SD')                         % Drift
                    ELEMENT(nelem).length=str2num(list{3});
                end
                if strcmp(list{2},'QP') | strcmp(list{2},'SX')  % cas multipole
                    ELEMENT(nelem).length=str2num(list{3});
                    ELEMENT(nelem).strength=str2num(list{4});
                end
                if strcmp(list{2},'DI')  % dipole
                    ELEMENT(nelem).length=str2num(list{3})*str2num(list{4}); %length
                    ELEMENT(nelem).strength=[str2num(list{4}) str2num(list{5})];   %rho  n
                end
                if strcmp(list{2},'CO')  % coin dipole
                    ELEMENT(nelem).length=0;
                    %ELEMENT(nelem).strength=tan(str2num(list{3}))/str2num(list{4});
                    ELEMENT(nelem).strength=[str2num(list{3}) str2num(list{4}) str2num(list{5})];% teta rho Lff
                end         
                if strcmp(list{2},'BH')   % bend 
                    list=[list ; strread(char(txt{i+1}),'%s')]; % add second ligne
                    ELEMENT(nelem).length=str2num(list{3})*str2num(list{4});         %length
                    ELEMENT(nelem).strength=[str2num(list{4}),str2num(list{5}),...   %rho  n
                            str2num(list{7}),str2num(list{11}),str2num(list{8})];    %teta1 teta2 lff                     
                end  
                if strcmp(list{2},'CH')   % Cavity section : E  dE  phi freq 
                    ELEMENT(nelem).strength=[0 str2num(list{4})/str2num(list{3}) str2num(list{5}) str2num(list{7})] ;
                end  
                if strcmp(list{2},'QP')  % Insertion device rho
                    ELEMENT(nelem).strength=str2num(list{4});
                end
                if  strcmp(list{2},'ID')  % Insertion device rho
                    ELEMENT(nelem).length=str2num(list{3});
                    ELEMENT(nelem).strength=[str2num(list{4}) str2num(list{5})];
                end  
                if  strcmp(list{2},'HC')  % Corrector H
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=0;
                end  
                if  strcmp(list{2},'VC')  % Corrector V
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=0;
                end            
                if  strcmp(list{2},'HP')  % BPM
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=0;
                end   
                if  strcmp(list{2},'VP')  % BPM
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=0;    
                end    
                if  strcmp(list{2},'OB')  % Observation point
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=0;    
                end                  
                 if  strcmp(list{2},'SF')  % Electrical thin LENS from coil focusing
                    ELEMENT(nelem).length=0;
                    ELEMENT(nelem).strength=str2num(list{3})*str2num(list{4})^2;
                end    
            end
        end   
    end
end
nelem_ELEMENT=nelem;
if (nargin<3);fprintf('  Found %d element list    \n',nelem_ELEMENT);end
% for j=1:ntype
%     fprintf('    Found %d %s families    \n',family(j),element_type{j})
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get lattice
% in block *** STRUCTURE ***, n=5
nl1=block_line(5)+2;
nl2=block_line(6)-1;
lattice_vector=[];
for i=nl1:nl2
    ligne=txt{i};
    list=strread(char(ligne),'%s');
    lattice_vector=[lattice_vector ; list];
end
% Make structure
nelem_LATTICE=length(lattice_vector);
if (nargin<3);fprintf('  Found %d element lattice    \n',nelem_LATTICE);end
LATTICE = cell2struct(lattice_vector, 'name', nelem_LATTICE);
% Get position in element/remove if no element
for i=1:nelem_LATTICE
    elem_lattice=LATTICE(i).name;
    LATTICE(i).num=0;% removed afterward
    for j=1:nelem_ELEMENT
        elem_element=ELEMENT(j).name;
        if strcmp(elem_lattice,elem_element)
            LATTICE(i).num=j;
            j=nelem_ELEMENT; % to stop
        end
    end
end
% remove empty ELEMENT
ind=find(cat(1,LATTICE.num)==0);
LATTICE(ind)=[];


nelem_LATTICE=length(LATTICE);
% Add element fields : type & div & err  &  pipe
err0=0;
pipe0=[0.05 0.05]; % Default pipe H & V
for i=1:nelem_LATTICE
    num=LATTICE(i).num;
    LATTICE(i).type=ELEMENT(num).type;
    LATTICE(i).div=[1 1];
    LATTICE(i).err   =err0; 
    LATTICE(i).pipe  =pipe0; 
end


% Get periode
% in block *** periode ***, n=6
nl1=block_line(6)+1;
ligne=txt{nl1};list=strread(char(ligne),'%s');
lattice_periode=str2double(list{1});
% to implement on lattice struct


%Get warning for BEND from beta
warn_BH=0;
nelem=length(LATTICE);
for i=1:nelem
    name=LATTICE(i).name;
    if strcmp(name,'BH')
        warn_BH=1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get data : beta,dispersion,energy
% in block *** energy ***, n=11
nl1=block_line(11)+1;
ligne=txt{nl1};list=strread(char(ligne),'%s');
energy=str2num(list{1});
ligne=txt{nl1+1};list=strread(char(ligne),'%s');
restmass=str2num(list{1});
% in block *** emittance ***, n=12
nl1=block_line(12)+1;
ligne=txt{nl1};list=strread(char(ligne),'%s');
emittance=[str2num(list{1}) str2num(list{2}) str2num(list{3})];
% in block *** dispersion ***, n=9
nl1=block_line(9)+1;
ligne=txt{nl1};list=strread(char(ligne),'%s');
dispersion=[str2num(list{1}) str2num(list{2})];
ligne=txt{nl1+1};list=strread(char(ligne),'%s');
dispersion=[dispersion str2num(list{1}) str2num(list{2}) 0 1];
% in block *** beam matrix ***, n=8
beta=eye(6)*0;
nl1=block_line(8)+1;
ligne=txt{nl1};list=strread(char(ligne),'%s');
beta(1,1)=[str2num(list{1})];
ligne=txt{nl1+1};list=strread(char(ligne),'%s');
beta(1,2)=str2num(list{1});beta(2,1)=beta(1,2);
beta(2,2)=str2num(list{2});
ligne=txt{nl1+2};list=strread(char(ligne),'%s');
beta(3,3)=str2num(list{3});
ligne=txt{nl1+3};list=strread(char(ligne),'%s');
beta(3,4)=str2num(list{3});beta(4,3)=beta(3,4);
beta(4,4)=str2num(list{4});

DYNAMIC.file=input_file;
DYNAMIC.energy=energy;
DYNAMIC.restmass=restmass;
DYNAMIC.period=lattice_periode;
DYNAMIC.emittance=emittance';
DYNAMIC.twiss=beta;
DYNAMIC.disp=dispersion';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Complete LATTICE0 with :
%                     .length   element length
%                     .pos      end element pos in lattice
%                     .matrix   6*6 transfert matrix
%                     .twiss    6*6 twiss matrix
%                     .disp     6 disp vector
%                     .chro     2 chro vector
% matrix, twiss and disp
lattice_fill;
LATTICE0=LATTICE;  % save base for future splitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin<3);
fprintf('Beta elements supported are  : %s %s %s %s %s %s %s %s only\n',element_type{1:8})
end
if warn_BH==1
   fprintf('BH type found in lattice : not supported by split_lattice \n')
end
if (nargin<3);fprintf('Global Structure ELEMENT, LATTICE and DYNAMIC done    \n');end
return
