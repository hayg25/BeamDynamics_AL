function [Lsat,Lsat1d,Psat,Psat1d,Lg,Lg1d,Pn,P,B] = get_Lsat_FEL_optic( Lp,Lw,eps,sige,I,beta,E0,L )
%  GET_LSAT_FEL Summary of this function goes here
%  Based on Ming-Xie formulae PAC 95
%  DESIGN OPTIMIZATION FOR AN X-RAY FREE ELECTRON LASER DRIVEN BY SLAC LINAC
%  

% Match slive input data dimension
% Slice eps sige and I are constant along undulator but not beta
% so beta may have +1 dimension than eps, sige and I
n1=max([ndims(eps) ndims(sige) ndims(I)])
n2=ndims(beta)


[Lsat,Lsat1d,Psat,Psat1d,Lg,Lg1d,Pn,P,B] = get_Lsat_FEL( Lp,Lw,eps,sige,I,beta,E0,L );


end

