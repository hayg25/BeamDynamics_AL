function lattice_fill
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC
% Complet LATTICE with length pos, matrix, twiss and disp and err
global ELEMENT LATTICE DYNAMIC
% 

nelem=length(LATTICE);
for i=1:nelem
    num=LATTICE(i).num;
    LATTICE(i).strength=ELEMENT(num).strength;
end

%
[pos]=get_position;
[energ]=get_energy; % to add
[matrix]=get_matrix;
[twiss]=get_twiss;
[disp]=get_disp;
[chro]=get_chro(disp(:,2));
TT=eye(6);
flag=0;nco=0;
for i=1:nelem
    if ~(strcmp(LATTICE(i).type,'CO'));flag=0;end;
    
    if  (strcmp(LATTICE(i).type,'CO')) && (strcmp(LATTICE(i+1).type,'DI'));flag=-1;end; % Entrance edge
    
    if  (strcmp(LATTICE(i).type,'CO')) && (strcmp(LATTICE(i-1).type,'DI'));flag=+1;end; % Exit edge
    
    LATTICE(i).length=squeeze(pos(i,1));
    LATTICE(i).pos   =squeeze(pos(i,2));
    LATTICE(i).energy=squeeze(energ(i,:));
    LATTICE(i).matrix=squeeze(matrix(i,:,:));
    LATTICE(i).twiss =squeeze(twiss(i,:,:));
    LATTICE(i).disp  =squeeze(disp(i,:))';
    LATTICE(i).chro  =squeeze(chro(i,:));
    LATTICE(i).flag  =flag; 
    TT=squeeze(matrix(i,:,:))*TT;
    if  (strcmp(LATTICE(i).type,'CO')) && nco==1;flag=-1;nco=0;end; % Entrance edge
end

%LATTICE0=LATTICE;  % save base for future splitting
DYNAMIC.matrix=TT; % total matrix

return

