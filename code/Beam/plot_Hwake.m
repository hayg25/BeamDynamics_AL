function plot_Hwake(n_period)
% track one particles with energy kick
% get emittance from central trajectory     Ec
% get emittance from dispersion trajectory  Ed
% with one E jump / continuous E jump / random E jump
global  LATTICE DYNAMIC
%
if nargin==0 ; n_period=1;end
%   
% at beginning
X=[0 ;0 ;0 ;0 ;0 ;0];

% optic data
twiss0=DYNAMIC.twiss; %first
bx0 =twiss0(1,1);
ax0 =twiss0(1,2);
gx0 =twiss0(2,2);
twiss=cat(3,LATTICE.twiss);
bx =squeeze(twiss(1,1,:));
ax =squeeze(twiss(1,2,:));
gx =squeeze(twiss(2,2,:));
% 
disp0=DYNAMIC.disp; %first
disp=cat(2,LATTICE.disp);

%
% get matrix
matrix=cat(3,LATTICE.matrix);
%
% Horizontal emittance of input X
Ec=bx0.*X(2).*X(2)-2*ax0.*X(1).*X(2)+gx0.*X(1).*X(1);
Xd=X-disp0*X(6);
Ed=bx0.*Xd(2).*Xd(2)-2*ax0.*Xd(1).*Xd(2)+gx0.*Xd(1).*Xd(1);


% track from 1 to nelem
pos=0;
nelem=length(LATTICE);
for j=1:n_period
    for i=1:nelem
        T=matrix(:,:,i);
        X=T*X;

        %if i==100;X(6)=X(6)+1; end; %one E jump
        X(6)=X(6)+1e-5;          %contituous E jump
        %X(6)=X(6)+1e-5*randn(1);  %random E jump

        % Horizontal emittance
        Hc=bx(i).*X(2).*X(2)  -2*ax(i).*X(1).*X(2)  +gx(i).*X(1).*X(1);
        Ec=[Ec Hc];
        Xd=X-disp(:,i)*X(6);
        Hd=bx(i).*Xd(2).*Xd(2)-2*ax(i).*Xd(1).*Xd(2)+gx(i).*Xd(1).*Xd(1);
        Ed=[Ed Hd];
        
        pos  =[pos ; LATTICE(i).length] ;
    end
end
pos=cumsum(pos);

figure(1)
plot(pos,Ec*0,'-r');hold on;
plot(pos,Ed,'-b');hold off;
xlabel('S (m)');ylabel('Emitteanc (m.rad)')
xlim([0 pos(length(pos))])
legend('Emt central','Emt disp')
grid on



return