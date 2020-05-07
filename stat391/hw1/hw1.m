clear all; close all; clc;
english=importdata('english.dat');
french=importdata('french.dat');
german=importdata('german.dat');
spanish=importdata('spanish.dat');
S1=' La verite vaut bien qu¡¯on passe quelques annees sans la trouver';
S2='Val piu la pratica della grammatica';
S3='From what we get, we can make a living; what we give, however, makes a life';
S4='Las cuentas, claras, y el chocolate, espes';
S5='Wir finden in den Buchern immer nur uns selbst. Komisch, dass dann allemal die Freude gross ist und wir den Autor zum Genie erklaren.';
S6='Darkness cannot drive out darkness; only light can do that. Hate cannot drive out hate; only love can do that.';
sentence=char(S1,S2,S3,S4,S5,S6);
alphabet='abcdefghijklmnopqrstuvwxyz';
counts=zeros(6,26);
for i=1:6
    for j=1:26
        counts(i,j)=length(find(lower(sentence(i,:))==alphabet(j)));
    end
end

El=english.data/1000;
Gl=german.data/1000;
Sl=spanish.data/1000;
Fl=french.data/1000;
EGSF=[El Gl Sl Fl];
languages=["English","German","Spanish","French"];

for i=1:6
    prob=[1 1 1 1];
    for j=1:26
        prob=prob.*power(EGSF(j,:),counts(i,j));
    end
    prob=log2(prob);
    [M,I]=max(prob);
    result(i)=languages(I);
end
result