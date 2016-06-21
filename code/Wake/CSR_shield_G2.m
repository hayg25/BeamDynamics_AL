function CSR_shield_G2
% CSR shield
% Compute G2 term Murphy,Krinsky,Gluckstern + Debernev


h=0.01;
rho=5.4;
delta=h/rho

xx=[];
ss=-50:0.01:50;
G2=0*[1:length(ss)];
for k=1:25;
    k
    G2k=[];
    for s=ss
        if s<0
            x = fzero(@(x)fpp(x,s,k),[0 10]);
        else
            x = fzero(@(x)fpp(x,s,k),[0 10]);
        end
       
        xx=[xx x];
        tt=2*(-1)^(k+1)/k^2*( 4*x^4*(3-x^4)/(1+x^4)^3 );
        G2k=[G2k tt];
    end
    G2=G2+G2k;
end
x=ss;


save CSR_shield.mat x G2
plot(ss,G2)
grid on