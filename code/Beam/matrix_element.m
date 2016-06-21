function [T]=matrix_element(type,length,strength,div)
% get the matrix versus type
if div<=1 ; div=1; end;
length=length/div; 
if     strcmp(type,'SD')
    [T]=matrix_drift(length);
elseif strcmp(type,'QP')   
    [T]=matrix_quad(length,strength);
elseif strcmp(type,'DI')
    [T]=matrix_diph(length,strength(1),strength(2));
elseif strcmp(type,'CO')
    [T]=matrix_coin(strength);
elseif strcmp(type,'BH')
    % warning not correct for div
    T1=matrix_coin([strength(3) strength(1) strength(5)]);
    TD=matrix_diph(length,strength(1),strength(2));
    T2=matrix_coin([strength(4) strength(1) strength(5)]);
    T=T2*TD*T1;
elseif strcmp(type,'RF')
    [T]=matrix_RF(strength);
elseif strcmp(type,'CH')
    [T]=matrix_CH(length,strength);
elseif strcmp(type,'ID')   
    [T]=matrix_ID(length,strength);  
  elseif strcmp(type,'SF')   
    [T]=matrix_ELENS(strength);    
else
    T=eye(6);  % for unknown elements or multipole kick
end


return