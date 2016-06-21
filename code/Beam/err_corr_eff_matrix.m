function [MCX,MCZ,nhp,nvp,nhc,nvc]=err_corr_eff_matrix(nhc,nvc,nhp,nvp)
% Get CORR and BPM index on lattice (nhp,nvp,nhc,nvc)
% or use the nargin if exist
% Get H & V matrix to reverse  (MCX MCZ) hc1 hc2 etc ...
% (x1 x2 etc ) = MCX (hc1 hc2 etc ...) for each BPM
% corr values given by -inv(MCX)*(x_nocorr)
% Works for a line (not a ring)
global  LATTICE

if nargin==0
    % Get CORR and BPM index on lattice by default
    nhc=lattice_index('HC','type');% corr H
    nvc=lattice_index('VC','type');% corr V
    nhp=lattice_index('HP','type');% bpm H
    nvp=lattice_index('VP','type');% bpm H
else
end

% Get H matrix to reverse
MCX=zeros(length(nhp),length(nhc));
for i=1:length(nhc)
    n1=nhc(i);
    for j=1:length(nhp)
        n2=nhp(j);
        T=eye(6,6);
        for k=n1:n2;T=squeeze(LATTICE(k).matrix)*T;end
        MCX(j,i)=T(1,2);
    end
end

% Get V matrix to reverse
MCZ=zeros(length(nvp),length(nvc));
for i=1:length(nvc)
    n1=nvc(i);
    for j=1:length(nvp)
        n2=nvp(j);
        T=eye(6,6);
        for k=n1:n2;T=squeeze(LATTICE(k).matrix)*T;end
        MCZ(j,i)=T(3,4);
    end
end
