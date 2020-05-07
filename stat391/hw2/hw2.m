clear all; close all; clc;
theta_1 = 0.3141;
theta_ML = zeros(1,100);
for i = 1:101
    choose = 1;
    for j=1:i-1
        choose = choose*(101 - j)/(i-j);
    end
    theta_ML(i)=theta_1^(i-1)*(1-theta_1)^(101-i)*choose;
end
stem(0:0.01:1,theta_ML)
xlabel('\theta_1^{ML}')
title('Probability of guessing \theta_1')

