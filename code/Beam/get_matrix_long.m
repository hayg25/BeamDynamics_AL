function [M]=get_matrix_long(r56,E,Vrf,Frf,phis,mod)
% make matrix, no damping
% mode=1 ; start = juste after cavity  (default)
% mode=2 ; start = at mid r56 (opposite from mid cavity)
% mode=3 ; start = juste before cavity  
% mode=4 ; start = at mid r56 (opposite from mid cavity)

mode=1;
if(nargin>5); mode=mod; end

c=3e8;
kl=2*pi*Frf/c;
% 
V=Vrf;         
r65=kl*V*sin(phis)/E;
r66=1;

%
T   = [ 1  r56/2 ; 0 1] ;       %  2D 1 turn matrice
Trf = [1   0  ; r65/2  r66] ;   %  2D rf/2 matrix

% make 1 turn matrix 
if     mode==1  
   M=Trf*Trf*T*T;
elseif mode==2
   M=T*Trf*Trf*T;
elseif mode==3
   M=T*T*Trf*Trf;  
elseif mode==4
   M=Trf*T*T*Trf;   
end
return 
   
