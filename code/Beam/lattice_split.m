function lattice_split(div,type)
%  Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
%  increase split lattice according to type and div
%  LATTICE size increase according to number of subdivision
%  ns=1  by default  stop at each end of element
%  ns=2  add a stop in the middle of each element with lenght>Lmin
%  Can be cumulated
%  type can be either a type(target all QP) or a name (target 1 QP)
%  If div > 1 split element by div
%  If div < 1 split element by n so that length = div in meter

global ELEMENT LATTICE

%
% Check if element type BEND is used
elem_type='all';
if nargin < 1,  div=1; end
if nargin == 2, elem_type=type; end
%
Lmin=0.001;
LATTICE0=LATTICE;
nelem=length(LATTICE0);

for i=1:length(ELEMENT)
    ELEMENT(i).div=1;
end
if div>1                       % split element
    j=0;
    for i=1:nelem               % run over LATTICE0
        j=j+1;
        LATTICE(j)=LATTICE0(i);
        L=LATTICE0(i).length;
        num=LATTICE0(i).num;
        T=ELEMENT(num).type;
        N=ELEMENT(num).name;
        
        L_cond=false;T_cond=false;
        if L>Lmin ; L_cond=true; end
        if strcmp(elem_type,T)||strcmp(elem_type,N); T_cond=true; end
        if strcmp(elem_type,'all'); T_cond=true; end
        
        if L_cond  && T_cond        % split egal element by div and increment LATTICE
            LATTICE(j).div=[div 1]; % first element
            for k=1:(div-1)
                j=j+1;
                LATTICE(j)=LATTICE0(i);
                LATTICE(j).div=[div (k+1)];   %j-iem element
                num=LATTICE0(i).num;
                ELEMENT(num).div=div;
            end
        end
    end
    LATTICE=LATTICE';
end
%
if div<1                       % split element according length div m max
    Lmin=div;
    j=0;
    for i=1:nelem               % run over LATTICE0
        j=j+1;
        LATTICE(j)=LATTICE0(i);
        L=LATTICE0(i).length;
        num=LATTICE0(i).num;
        T=ELEMENT(num).type;
        N=ELEMENT(num).name;
        
        div=floor(L/Lmin);
        L_cond=false;T_cond=false;
        if L>Lmin ; L_cond=true; end
        if strcmp(elem_type,T)||strcmp(elem_type,N); T_cond=true; end
        if strcmp(elem_type,'all'); T_cond=true; end
        
        
        if L_cond  && T_cond        % split egal element by div and increment LATTICE
            LATTICE(j).div=[div 1]; % first element
            for k=1:(div-1)
                j=j+1;
                LATTICE(j)=LATTICE0(i);
                LATTICE(j).div=[div (k+1)];   %j-iem element
                num=LATTICE0(i).num;
                ELEMENT(num).div=div;
            end
        end
    end
    LATTICE=LATTICE';
end


% New structure LATTICE
lattice_fill;
return
