% Esercizio 3.23
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:11 CET

A = [0 0 0 1; 2 0 0 0; 0 3 0 0; 0 0 4 0], b=[4; 58; 2; 7]
x = risolviSistemaLUpivoting(A, b)
A*x-b

A = [-23 5 -21 8; 0 0 5 7; 1 54 7 9; 0 -8 12 4], b=[10; -4; 76; 23]
x = risolviSistemaLUpivoting(A, b)
A*x-b