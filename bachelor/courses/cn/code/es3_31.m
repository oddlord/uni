% Esercizio 3.31
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:11 CET

A = [3 2 1; 1 2 3; 1 2 1; 2 1 2]
b = [10; 10; 10; 10]
x = risolviSistemaQR(A,b)
r = A*x-b
disp('norma di r: '), norm(r, 2)^2