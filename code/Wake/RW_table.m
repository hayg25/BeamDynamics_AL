%function RW_table
% make lookup table for RW

alpha=0;
xmax=10;
dx=xmax/1000;
x=0:dx:xmax;

ff=(x.*x)./(power(x,6)+8).*exp(-x.*x*alpha);

% figure(1)
% plot(x,ff)
% grid on

tint=[];
alpha=0:0.01:20;
for a=alpha;
  int=sum( (x.*x)./(power(x,6)+8).*exp(-x.*x*a) )*dx;
  tint=[tint int];
end
length(tint)

% % asymptote for alpha > 20
alphas=20:1:200;
tints=sqrt(pi)/32*power(1./alphas,1.5);

figure(2)
semilogy(alpha,tint,'-b'); hold on
semilogy(alphas,tints,'-r'); hold off
grid on

save RW_table.mat alpha tint

