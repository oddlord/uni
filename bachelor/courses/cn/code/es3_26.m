% Esercizio 3.26
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:11 CET

format short e
A=eye (10)+100*[ zeros(1 ,10); eye (9) zeros(1 ,9)'];
b=[1 101* ones(1 ,9)]';
x (1)= b (1); for i=2:10 , x(i)=b(i) -100*x(i -1); end
x=x(:)

c =0.1*[1 101* ones(1 ,9)]';
y (1)= c (1); for i=2:10 , y(i)=c(i) -100*y(i -1); end
y=y(:)

norm (A)* norm (inv(A))* norm (c-b)/ norm (b)