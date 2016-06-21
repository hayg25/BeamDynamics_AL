function lattice_list
% list elem in lattice 
global ELEMENT LATTICE

nl  =length(LATTICE);
% 
fprintf('\n')


j=1;
synopt(j,j:2)=0;
for i=1:nl
    
    name=LATTICE(i).name;
    type=ELEMENT(LATTICE(i).num).type;
    pos =LATTICE(i).pos;
    len =LATTICE(i).length;
    fprintf('%3.0f   %10s   %5s   %5.2f  %5.2f\n',i,name, type, len, pos)
    
    h=0;
    if strcmp(type,'QP'); h=1.0*sign(ELEMENT( LATTICE(i).num ).strength); end;
    if strcmp(type,'DI'); h=0.5; end;
    
    
    j=j+1;
    synopt(j,1)=pos-len;
    synopt(j,2)=0;
    j=j+1;
    synopt(j,1)=pos-len;
    synopt(j,2)=h;
    j=j+1;
    synopt(j,1)=pos;
    synopt(j,2)=h;
    j=j+1;
    synopt(j,1)=pos;
    synopt(j,2)=0;

   
    
end
fprintf('\n')


figure(50)
plot(synopt(:,1),synopt(:,2))
ylim([-1.5 1.5])
