clear all; close all; clc;
sentence = fileread('hw3-mlk-letter-estimation.txt');
alphabet='abcdefghijklmnopqrstuvwxyz';
n=zeros(1,26);
%% a
for i=1:26
	n(i)=length(find(lower(sentence)==alphabet(i)));
end

%% b
k=0;
R{1}=find(n+1==1);
for i=1:max(n)
    if sum(n==i) ~= 0
        R{length(R)+1} = find(n==i);
        k(length(k)+1) = i;
    end
end

%% c
r(1)=sum(n==0);
k=0:max(n);
for i=k
    r(i+1)=sum(n==i);
end

m=sum(r);

%%
for i=1:length(R)
    selected_letter(i)=R{i}(1);
end
letters=char('a'+selected_letter-1);
%% d
for i=1:26
    theta_ML(i) = n(i)/sum(n);
end
%% e
for i=1:26
    theta_Lap(i) = (n(i)+1)/(sum(n)+m);
end
%% f
for i=1:26
    if n(i)==0
        theta_GT(i) = r(2)/sum(n)/r(1);
    else
        theta_GT(i) = theta_ML(i) * (1 - r(2) / sum(n));
    end
end
%% g
D = 0;
for i=1:26
    D = D + min(n(i),1);
end

for i=1:26
    n_NE(i) = n(i) - min(n(i),1) + D / m;
    theta_NE(i) = n_NE(i) / sum(n);
end

%% h
large_test = fileread('hw3-test-letter-estimation.txt');
for i=1:26
	test_n(i)=length(find(lower(large_test)==alphabet(i)));
end

large_likelihood_ML = 0;
for i=1:26
    large_likelihood_ML = large_likelihood_ML + test_n(i)*log2(theta_ML(i));
end

large_likelihood_Lap = 0;
for i=1:26
    large_likelihood_Lap = large_likelihood_Lap + test_n(i)*log2(theta_Lap(i));
end

large_likelihood_GT = 0;
for i=1:26
    large_likelihood_GT = large_likelihood_GT + test_n(i)*log2(theta_GT(i));
end
large_likelihood_NE = 0;
for i=1:26
    large_likelihood_NE = large_likelihood_NE + test_n(i)*log2(theta_NE(i));
end


test_ML = 0;
for i=1:26
    test_ML = test_ML + n(i)*log2(theta_ML(i));
end

test_Lap = 0;
for i=1:26
    test_Lap = test_Lap + n(i)*log2(theta_Lap(i));
end

test_GT = 0;
for i=1:26
    test_GT = test_GT + n(i)*log2(theta_GT(i));
end

test_NE = 0;
for i=1:26
    test_NE = test_NE + n(i)*log2(theta_NE(i));
end

