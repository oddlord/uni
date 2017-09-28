% Esercizio 1.17
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:10 CET

x1=0.12345678
x2=-0.12341234
y=0.00004444

x1t=0.1235
x2t=-0.1234
yt=x1t+x2t

e1=(x1t-x1)/x1
e2=(x2t-x2)/x2
ey=(yt-y)/y

k=(abs(x1)+abs(x2))/abs(x1+x2)
ex=e1

ey_max=k*ex