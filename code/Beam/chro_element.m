function [ksx,ksz]=chro_element(type,length,strength,div,dpx,flag)
% get the chromatiq term versus type
% focusing term = chromatic*delta
if div<=1 ; div=1; end;
length=length/div; 
if     strcmp(type,'SD')
    ksx=0;ksz=0;
elseif strcmp(type,'QP')   
    ksx=+length*strength;
    ksz=-ksx;
elseif strcmp(type,'DI')
    ksx=+length/strength(1)^2; % factor 2 to be checked !
    ksz=0;
elseif strcmp(type,'CO')
    % flag=0  entrance
    % flag=1  exit
    if flag==1;dpx=-dpx;end;
    ksx=+( tan(-strength(1) + dpx)/strength(2) );
    ksz=-( tan(-strength(1) + dpx)/strength(2) );
else
    ksx=0;ksz=0;  % for unknown elements
end

return