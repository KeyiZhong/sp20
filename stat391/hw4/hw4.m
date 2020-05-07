clear all; close all; clc;
%% 1.1
ugrad=importdata('hw4-ugrad.dat');
mu_ML=mean(ugrad);
sigma_ML=mean((ugrad-mu_ML).^2);
x=0:0.01:16;
plot(x,normpdf(x,mu_ML,sigma_ML));

%% 1.2
chair=importdata('hw4-chair.dat');
a(1)=0.2;
b(1)=0.2;
step=0.00001;
tolerance=0.00001;
n=length(chair);

for i=1:100000
    dl_da(i)=n/a(i);
    dl_db(i)=0;
    for j=1:n
        temp=(1-exp(-a(i)*chair(j)-b(i)))/(1+exp(-a(i)*chair(j)-b(i)));
        dl_da(i)=dl_da(i)-chair(j)*temp;
        dl_db(i)=dl_db(i)-temp;
    end
    a(i+1)=a(i)+step*dl_da(i);
    b(i+1)=b(i)+step*dl_db(i);
    l(i)=n*log(a(i))-a(i)*sum(chair)-n*b(i)-2*sum(log(1+exp(-a(i).*chair-b(i))));
    if i>1&&abs(l(i)/l(i-1)-1)<tolerance
        break
    end
end
a_ML=a(length(a));
b_ML=b(length(b));
for i=1:length(x)
    logisticpdf(i)=(a_ML*exp(-a_ML*x(i)-b_ML))/(1+exp(-a_ML*x(i)-b_ML))^2;
end
plot(l)
figure
plot(x,logisticpdf)
hold on
plot(x,normpdf(x,mu_ML,sigma_ML))

%% 1.3
coke=importdata('hw4-coke.dat');
a_ML_unif=min(coke);
b_ML_unif=max(coke);
correction=0.1*(b_ML_unif-a_ML_unif)/length(coke);
a_ML_unif=a_ML_unif-correction;
b_ML_unif=b_ML_unif+correction;
unif_x=a_ML_unif:0.01:b_ML_unif;
unif=repelem(1/(b_ML_unif-a_ML_unif),length(unif_x));

plot(unif_x,unif)

%% 1.4
unknown=importdata('hw4-unknown.dat');
norm=0;
logistic=0;
uniform=0;
for i=1:length(unknown)
    norm=norm+log(normpdf(unknown(i),mu_ML,sigma_ML));
    logistic=logistic+log((a_ML*exp(-a_ML*unknown(i)-b_ML))/(1+exp(-a_ML*unknown(i)-b_ML))^2);
    uniform=uniform+log(1/(b_ML_unif-a_ML_unif));
end
norm
logistic
uniform

%% 1.5
a(1)=0.2;
b(1)=0.2;
step=0.00001;
tolerance=0.00001;
n=length(unknown);

for i=1:100000
    dl_da(i)=n/a(i);
    dl_db(i)=0;
    for j=1:n
        temp=(1-exp(-a(i)*unknown(j)-b(i)))/(1+exp(-a(i)*unknown(j)-b(i)));
        dl_da(i)=dl_da(i)-unknown(j)*temp;
        dl_db(i)=dl_db(i)-temp;
    end
    a(i+1)=a(i)+step*dl_da(i);
    b(i+1)=b(i)+step*dl_db(i);
    l(i)=n*log(a(i))-a(i)*sum(unknown)-n*b(i)-2*sum(log(1+exp(-a(i).*unknown-b(i))));
    if i>1&&abs(l(i)/l(i-1)-1)<tolerance
        break
    end
end
a_ML=a(length(a));
b_ML=b(length(b));
for i=1:length(x)
    logisticpdf(i)=(a_ML*exp(-a_ML*x(i)-b_ML))/(1+exp(-a_ML*x(i)-b_ML))^2;
end

plot(x,logisticpdf)

%% 2.5

for N=1:1000
    x=exprnd(ones(1,100));
    for i=1:100
        if x(i)>1
            y(i)=1;
        else
            y(i)=0;
        end
    end

    gamma_ML(N)=100/sum(x);
    gamma_c(N)=log(100/sum(y));
end
histogram(gamma_c)
figure
histogram(gamma_ML)