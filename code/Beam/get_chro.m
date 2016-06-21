function [chro]=get_chro(dpx)
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% return a chro list per element chro(i,:)=[ksx ksz];
global ELEMENT LATTICE


% Case apply kick at each element exit
nelem=length(LATTICE);
chro(1:nelem,1:2)=0;
flag=0;
for i=1:nelem
    num=LATTICE(i).num;
    if (i>1) && (strcmp(ELEMENT(num).type,'DI'));flag=1;end; % to locate coin entrance dipole
    [ksx,ksz]=chro_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div,dpx(i),flag);
    chro(i,:)=[ksx ksz];
    %fprintf('%5s  %d  %d  %d \n',ELEMENT(num).type,flag,[ksx ksz])
    if (i>1) && (strcmp(ELEMENT(num).type,'CO'));flag=0;end; % to locate coin exit dipole
end


% % Case share kick at each element entrance / exit
% nelem=length(LATTICE);
% chro(1:nelem,1:2)=0;
% flag=0;
% % first and last
% num =LATTICE(1).num;
% num1=LATTICE(nelem).num;
% [ksx,ksz]=chro_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div,dpx(1),flag);
% [ksx1,ksz1]=chro_element(ELEMENT(num1).type,ELEMENT(num1).length,ELEMENT(num1).strength,ELEMENT(num1).div,dpx(nelem),flag);
% chro(nelem,:)=[ksx+ksx1 ksz+ksz1]/2;
% 
% % rest of the lattice
% for i=2:nelem
%     num =LATTICE(i).num;
%     num1=LATTICE(i-1).num;
%     if (i>1) && (strcmp(ELEMENT(num).type,'DI'));flag=1;end; % to locate coin entrance dipole
%     [ksx,ksz]=chro_element(ELEMENT(num).type,ELEMENT(num).length,ELEMENT(num).strength,ELEMENT(num).div,dpx(i),flag);
%     [ksx1,ksz1]=chro_element(ELEMENT(num1).type,ELEMENT(num1).length,ELEMENT(num1).strength,ELEMENT(num1).div,dpx(i-1),flag);
%     chro(i-1,:)=[ksx+ksx1 ksz+ksz1]/2;
%     %fprintf('%5s  %d  %d  %d \n',ELEMENT(num).type,flag,[ksx ksz])
%     if (i>1) && (strcmp(ELEMENT(num).type,'CO'));flag=0;end; % to locate coin exit dipole
% end


