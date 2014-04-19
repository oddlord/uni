% Esercizio 3.32
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:12 CET

format short

x = linspace(0 ,10 ,101)';
A=[x, x .^0];
gamma = [0.5 0.1 0.05 0.01 0.005 0.001];

for i =1:6
y =10* x +5+( sin(x*pi ))* gamma (i);
a = A\y;
r = A*a-y;
fprintf ('gamma = %4.3 f',gamma (i))
fprintf ('\n\ tSenza fattorizzazione : '), a, norm (r)
[a,r]= risolviSistemaQR ( fattorizzaQR (A),y);
fprintf ('\ tCon fattorizzazione QR: '), a, r
end