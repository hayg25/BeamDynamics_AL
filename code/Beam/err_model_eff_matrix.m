function [MCX,MCZ,nhp,nvp,nhc,nvc]=err_model_eff_matrix(Helem,Velem)
% Helem=list of LATTICE.name to be use as errors to model the orbit
% Get H&Velem and BPM index on lattice (nhp,nvp,nhc,nvc)
% Get H & V matrix to reverse  (MCX MCZ) hc1 hc2 etc ...
% (x1 x2 etc ) = MCX (hc1 hc2 etc ...) for each BPM
% corr values given by -inv(MCX)*(x_nocorr)
% Works for a line (not a ring)
global  LATTICE

nel =length(LATTICE); 
% Get CORR and BPM index on lattice
ihc=0;ivc=0;ihp=0;ivp=0;
for i=1:nel
    type=LATTICE(i).type;
    name=LATTICE(i).name;
    for j=1:length(Helem)
        if strcmp(name,Helem{j});ihc=ihc+1;nhc(ihc)=i;end % model H
    end
    for j=1:length(Velem)
        if strcmp(name,Velem{j});ivc=ivc+1;nvc(ivc)=i;end % model V
    end
    if strcmp(type,'HP') ;ihp=ihp+1;nhp(ihp)=i;end %  bpm H
    if strcmp(type,'VP') ;ivp=ivp+1;nvp(ivp)=i;end %  bpm V
end

% if or(ihc==0,ivc==0,ihp==0,ivp==0)
%     MCX=0;MCZ=0;nhc=0;nvc=0;
%     return
% end

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
