function [bxt,bzt] = get_slice_optic(s_twiss,E,lambda,ond,L)
%   Return slice beta fuction H&V along undulator
%   bx[]

% Get undulator strength K
[K] = get_und_param(E,lambda,ond);

% Get initial Twiss 
bx= s_twiss(1,:);ax=-s_twiss(2,:);gx=(1+ax.^2)./bx;
bz= s_twiss(3,:);az=-s_twiss(4,:);gz=(1+az.^2)./bz;
nbin=length(bx);

% Linear track slices along undulator
bxt=[];bzt=[];
S=0:ond:L;
for s=S
    T=matrix_ID(s,(K)); %Step ondulator matrix
    Tx=T(1:2,1:2);
    Tz=T(3:4,3:4);
    for i=1:1:nbin
        Bx=Tx*[bx(i) -ax(i) ; -ax(i) gx(i)]*Tx';
        bxs(i)=Bx(1,1);
        Bz=Tz*[bz(i) -az(i) ; -az(i) gz(i)]*Tz';
        bzs(i)=Bz(1,1);
    end
    bxt=[bxt ; bxs];
    bzt=[bzt ; bzs];
end

end

