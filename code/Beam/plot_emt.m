function plot_emt(epsx,epsz,d,n_period)
% Run beta2code before and get Structure ELEMENT, LATTICE and DYNAMIC 
% plot env
% with geometric epx epsz and de/e
global LATTICE DYNAMIC
lattice_split(5)
%
if nargin==3 ; n_period=1;end
%
lattice_split(5)
% 
twiss0=DYNAMIC.twiss; %first
twiss=cat(3,LATTICE.twiss);
betax=[twiss0(1,1) ; squeeze(twiss(1,1,:))];
alphx=[twiss0(1,2) ; squeeze(twiss(1,2,:))];
gammx=[twiss0(2,2) ; squeeze(twiss(2,2,:))];
betaz=[twiss0(3,3) ; squeeze(twiss(3,3,:))];
alphz=[twiss0(3,4) ; squeeze(twiss(3,4,:))];
gammz=[twiss0(4,4) ; squeeze(twiss(4,4,:))];

% 
disp0=DYNAMIC.disp; %first
disp=cat(2,LATTICE.disp);
dispx =[disp0(1) ; disp(1,:)'];
dispxp=[disp0(2) ; disp(2,:)'];
pos  =[0 ; cat(1,LATTICE.pos)] ;
pos_end=pos(length(pos));
ss=cat(1,LATTICE.length);

%
sigx  =(epsx*betax + d^2*dispx.^2);
sigxp =(epsx*gammx + d^2*dispxp.^2)
sigxxp=(epsx*alphx + d^2*dispx.*dispxp);
emtx  =sqrt(sigx.*sigxp - sigxxp.^2);

sigz  =(epsz*betaz);
sigzp =(epsz*gammz);
sigzzp=(epsz*alphz);
emtz  =sqrt(sigz.*sigzp - sigzzp.^2);


% duplicate on super periode
emtx_p=[];emtz_p=[];pos_p=[];
posn=[0:n_period]*pos_end;
for i=1:n_period
    emtx_p=[emtx_p ; emtx];
    emtz_p=[emtz_p ; emtz];
    pos_p=[pos_p ; (pos+posn(i))];
end

% get lattice synopt
[synopt]=get_lattice;

figure(1)
plot(pos_p,emtx_p,'-r');hold on;
yl=ylim;plot(synopt(:,1),synopt(:,2)*(yl(2)-yl(1))/10+yl(1),'-k');
plot(pos_p,emtz_p,'-b');hold off;
xlabel('S (m)');ylabel('rms Emittance (m.rad')
legend('emtx','emtz')
set(gca,'FontSize',16)
xlim([0 pos_p(length(pos_p))])
%ylim([0 5])
grid on

return

