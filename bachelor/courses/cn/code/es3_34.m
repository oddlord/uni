% Esercizio 3.34
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:12 CET

format long
x =[1;2;1;2];
f= inline ('[x(1) -x (3)+(10^3* x(1) - sin(x (1))* cos(x (2)))/10; x(2) -x (4)+(2* x(2) - sin(x (1))* cos(x (2)))/10]');

for i =1:100
alpha = cos(x (1))* cos(x (2))/10;
beta = sin(x (1))* sin(x (2))/10;
J = [101 - alpha , beta ; -alpha , 1.2+ beta ];
y = CordeNonLin ( f, J, x, 10^ -5);
x = x +0.1* y;
end
[x (1); x (2)]