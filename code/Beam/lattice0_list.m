function lattice0_list
% list elem in lattice 
global ELEMENT LATTICE0 

nl  =length(LATTICE0);
% 
fprintf('\n')


j=1;
synopt(j,j:2)=0;
for i=1:nl
    
    name=LATTICE0(i).name;
    type=ELEMENT(LATTICE0(i).num).type;
    pos =LATTICE0(i).pos;
    len =LATTICE0(i).length;
    fprintf('%3.0f   %5s   %5s   %5.2f  %5.2f\n',i,name, type, len, pos)
    
    h=0;
    if type=='QP'; h=1.0*sign(ELEMENT( LATTICE0(i).num ).strength); end;
    if type=='DI'; h=0.5; end;
    
    
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
