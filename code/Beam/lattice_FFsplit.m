function lattice_FFsplit(div,type)
%  Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
%  use a lattice with only quad and dip
%  split quad & dip according to fringe field profile in *.mat 
%  increase split lattice from lattice0  (div)
%  LATTICE size increase according to number of subdivision
%  
% 
global ELEMENT LATTICE0 LATTICE
%
% Check if element type BEND is used
elem_type='all';
if nargin < 1,  div=1; end
if nargin == 2, elem_type=type; end
%
LATTICE=LATTICE0(1); % init lattice structure
Lmin=0.01;
nelem=length(LATTICE0);
% restore basic LATTICE to LATTIC0
LATTICE=LATTICE0;
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
        
        L_cond=false;T_cond=false;
        if L>Lmin ; L_cond=true; end
        if strcmp(elem_type,T); T_cond=true; end
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
% New structure LATTICE
lattice_fill;
return
