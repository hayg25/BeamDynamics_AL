function [synopt]=get_lattice
% to plot lattice synopt
global ELEMENT LATTICE0 

nl  =length(LATTICE0);
% 

j=1;
synopt(j,j:2)=0;
for i=1:nl
    
    name=LATTICE0(i).name;
    type=ELEMENT(LATTICE0(i).num).type;
    pos =LATTICE0(i).pos;
    len =LATTICE0(i).length;
    
    
    h=0;
    dh=0;
    if strcmp(type,'QP') 
        h=0.6;
        dh=0.4*sign(ELEMENT( LATTICE0(i).num ).strength); 
    end
    if strcmp(type,'DI')
        h=0.6;
    end
    if strcmp(type,'CH')
        h=0.7;
    end
    if strcmp(type,'ID')
        h=0.6;
    end
    if strcmp(type,'HC')
        h=1;
    end
    if strcmp(type,'VC')
        h=1;
    end
    
    j=j+1;
    synopt(j,1)=pos-len;
    synopt(j,2)=0;
    j=j+1;
    synopt(j,1)=pos-len;
    synopt(j,2)=h;
    j=j+1;
    synopt(j,1)=pos-len/2;
    synopt(j,2)=h+dh;
    j=j+1;
    synopt(j,1)=pos;
    synopt(j,2)=h;
    j=j+1;
    synopt(j,1)=pos;
    synopt(j,2)=0;
    
end


