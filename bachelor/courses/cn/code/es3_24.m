% Esercizio 3.24
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:11 CET

format short e
A=[ eps , 1; 1, 0], b =[1; 1/4]
A\b
L=[1 , 0; 1/ eps , 1], U=[ eps , 1; 0, -1/ eps]
L*U-A
U\(L\b)